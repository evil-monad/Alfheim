//
//  MainView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/19.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import CoreMedia

struct MainView: View {
  let store: Store<AppState, AppAction>
  #if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  #endif

  var body: some View {
    #if os(iOS)
    if horizontalSizeClass == .compact {
      ListNavigation(store: store)
    } else {
      SidebarNavigation(store: store)
    }
    #else
    SidebarNavigation(store: store)
    #endif
  }
}

/// iPad & Mac
struct SidebarNavigation: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    NavigationView {
      WithViewStore(store) { viewStore in
        Sidebar(store: store)
          .task {
            viewStore.send(.load)
          }
      }
      // detail view in iPad
      Text("Sidebar navigation")
    }
  }
}

struct Sidebar: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { vs in
      HomeView(store: store)
        .listStyle(.insetGrouped)
        .navigationBarTitle("Clic")
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Button {
              vs.send(.newTransaction)
            } label: {
              Image(systemName: "plus.circle")
            }
          }
          ToolbarItemGroup(placement: .bottomBar) {
            HStack {
              Button {
                vs.send(.cleanup)
              } label: {
                Image(systemName: "gear")
              }
              Spacer()
              Button {
                vs.send(.addAccount(presenting: true))
              } label: {
                Text("Add Account")
              }
            }
          }
        }
    }
  }
}

/// iOS
struct ListNavigation: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    NavigationView {
      WithViewStore(store) { viewStore in
        ContentView(store: store)
          .task {
            viewStore.send(.load)
          }
      }
    }
  }
}

struct ContentView: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { vs in
      HomeView(store: store)
        .listStyle(.insetGrouped)
        .navigationBarTitle("Clic")
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Button {
              vs.send(.newTransaction)
            } label: {
              Image(systemName: "plus.circle")
            }
          }
          ToolbarItemGroup(placement: .bottomBar) {
            HStack {
              Button {
                vs.send(.settings(.sheet(isPresented: true)))
              } label: {
                Image(systemName: "gear")
              }
              Spacer()
              Button {
                vs.send(.addAccount(presenting: true))
              } label: {
                Text("Add Account")
              }
            }
          }
        }
        .sheet(isPresented: vs.binding(get: \.isAddingAccount, send: AppAction.addAccount)) {
          AccountComposer(
            store: store.scope(
              state: \.accountEditor,
              action: AppAction.accountEditor),
            mode: .new
          )
        }
        .sheet(isPresented: vs.binding(get: \.settings.isPresented, send: { .settings(.sheet(isPresented: $0)) })) {
          SettingsView()
        }
    }
  }
}

struct HomeView: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { vs in
      List {
        Section {
          GridMenu(store: store)
            .listRowBackground(Color(.systemGroupedBackground))
            .buttonStyle(.plain)
            .onTapGesture {}
            .onLongPressGesture {}
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color(.systemGroupedBackground))
        .buttonStyle(.plain)

        Section {
          OutlineGroup(vs.rootAccounts, children: \.optinalChildren) { account in
            AccountRow(account: account)
              .contextMenu(account.root ? nil : ContextMenu {
                Button {
                  vs.send(.editAccount(presenting: true, account))
                } label: {
                  Label("Edit", systemImage: "pencil.circle")
                }

                Button(role: .destructive) {
                  vs.send(.deleteAccount(account))
                } label: {
                  Label("Delete", systemImage: "trash.circle")
                    .foregroundColor(.red)
                }
              })
          }
        } header: {
          Text("Accounts").font(.headline).foregroundColor(.primary)
        }
        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 16))
        .sheet(isPresented: vs.binding(get: \.isEditingAcount, send: { AppAction.editAccount(presenting: $0, nil) })) {
          AccountComposer(
            store: store.scope(
              state: \.accountEditor,
              action: AppAction.accountEditor),
            mode: .new
          )
        }
      }
      .buttonStyle(.plain)
    }
  }
}

/// Don't use AccountList in Home
/// children 更新时，不会刷新！
struct AccountList: View {
  let accounts: [Account]

  var body: some View {
    List(accounts, children: \.optinalChildren) { account in
      AccountRow(account: account)
    }
  }
}

private struct AccountRow: View {
  @Environment(\.managedObjectContext) var viewContext // FIXME: use store environment
  let account: Account

  var body: some View {
    ZStack {
      HStack {
        Text("\(account.emoji ?? "") \(account.name)")
        Spacer()
      }

      NavigationLink {
        OverviewView(store: Store(
            initialState: AppState.Overview(account: account),
            reducer: AppReducers.Overview.reducer,
            environment: AppEnvironment(context: viewContext)
          )
        )
      } label: {
        EmptyView()
      }
      .buttonStyle(.plain)
      .opacity(account.hasChildren ? 0: 1)
    }
  }
}

struct QuickMenu: View {
  let store: Store<AppState, AppAction>
  @State private var selection: Int? = nil
  private var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 18), count: 2)

  init(store: Store<AppState, AppAction>) {
    self.store = store
    self.columns = Array(repeating: .init(.flexible(), spacing: 18), count: 2)
  }

  var body: some View {
    WithViewStore(store) { vs in
      LazyVGrid(columns: columns, spacing: 18) {
        ForEach(vs.sidebar.menus) { item in
          Button {
            selection = item.id
          } label: {
            MenuRow(item: item, isSelected: selection == item.id)
          }
          .background(
            NavigationLink(tag: item.id, selection: $selection, destination: {
              Text(item.name)
            }, label: {
              EmptyView()
            })
          )
        }
      }
      .onLongPressGesture {}
    }
  }
}

struct GridMenu: View {
  @Environment(\.managedObjectContext) var viewContext // FIXME: use store environment
  let store: Store<AppState, AppAction>
  private var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 18), count: 2)

  init(store: Store<AppState, AppAction>) {
    self.store = store
    self.columns = Array(repeating: .init(.flexible(), spacing: 18), count: 2)
  }

  var body: some View {
    WithViewStore(store.scope(state: \.sidebar)) { vs in
      LazyVGrid(columns: columns, spacing: 18) {
        ForEach(vs.menus) { item in
          NavigationRow(
            tag: item.id,
            selection: vs.binding(get: \.selection?.id, send: { AppAction.selectMenu(selection: $0) })) {
              TransactionList(
                store: store.scope(state: \.transaction, action: AppAction.transaction)
              )
          } label: {
            MenuRow(item: item, isSelected: vs.selection?.id == item.id)
              .onTapGesture {
                vs.send(.selectMenu(selection: item.id))
              }
          }
        }
      }
      .onLongPressGesture {}
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
          // selection = nil
          vs.send(.selectMenu(selection: nil))
        }
      }
    }
  }
}

struct MenuRow: View {
  let item: AppState.Sidebar.MenuItem
  let isSelected: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Image(systemName: item.symbol).font(.title2).foregroundColor(item.color)
        Spacer()
        Text(item.value).font(.subheadline)
      }
      Text(item.name).font(.callout).fontWeight(.medium)
    }
    .padding(12)
    .background(Color(UIColor.systemGray4).opacity(isSelected ? 1.0 : 0.0))
    .background(.background)
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
  }
}

extension EdgeInsets {
  static let `default` = EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 16)
}

extension AppState.Sidebar.MenuItem {
  var color: Color {
    switch filter {
    case .all: return Color.red
    case .uncleared: return Color.gray
    case .repeating: return Color.yellow
    case .flagged: return Color.blue
    }
  }
}

#if DEBUG
//struct AccountMenu_Previews: PreviewProvider {
//  static var previews: some View {
//    VStack {
//      AccountMenu()
//    }
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .background(.secondary)
//  }
//}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Section(header: EmptyView()) {
        QuickMenu(store: AppStore(initialState: AppState(), reducer: AppReducers.appReducer, environment: AppEnvironment.default)).listRowBackground(Color.clear)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())

      Section(header: Text("Accounts").font(.headline).foregroundColor(.primary)) {
        Text("ABC")
      }
    }.listStyle(.insetGrouped)
  }
}
//struct MainView_Previews: PreviewProvider {
//  static var previews: some View {
//    MainView().environmentObject(AppStore(moc: viewContext))
//  }
//}
#endif
