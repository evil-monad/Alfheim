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
      Home(store: store)
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
      Home(store: store)
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
        .sheet(isPresented: vs.binding(get: \.isAccountEditorPresented,
                                       send: { .addAccount(presenting: $0) })) {
          AccountComposer(
            store: store.scope(
              state: \.accountEditor,
              action: AppAction.accountEditor),
            mode: .new
          )
        }
    }
  }
}

struct Home: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { vs in
      List {
        Section {
          QuickMenu(store: store)
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
          }
        } header: {
          Text("Accounts").font(.headline).foregroundColor(.primary)
        }
        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 16))
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

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack(alignment: .center, spacing: 18) {
        Button {
          selection = Item.all.rawValue
        } label: {
          MenuItem(item: Item.all.content)
        }
        .background(
          NavigationLink(destination: Text("All"), tag: Item.all.rawValue, selection: $selection, label: { EmptyView() })
        )

        Button {
          selection = Item.uncleared.rawValue
        } label: {
          MenuItem(item: Item.uncleared.content)
        }
        .background(
          NavigationLink(destination: Text("Uncleared"), tag: Item.uncleared.rawValue, selection: $selection, label: { EmptyView() })
        )
      }
      HStack(alignment: .center, spacing: 18) {
        Button {
          selection = Item.repeating.rawValue
        } label: {
          MenuItem(item: Item.repeating.content)
        }
        .background(
          NavigationLink(destination: Text("Repeating"), tag: Item.repeating.rawValue, selection: $selection, label: { EmptyView() })
        )
        Button {
          selection = Item.flagged.rawValue
        } label: {
          MenuItem(item: Item.flagged.content)
        }
        .background(
          NavigationLink(destination: Text("Flagged"), tag: Item.flagged.rawValue, selection: $selection, label: { EmptyView() })
        )
      }
    }
    .onLongPressGesture {}
  }

  enum Item: Int, Identifiable {
    var id: Int { rawValue }

    case all
    case uncleared
    case repeating
    case flagged

    struct Content {
      let text: String
      let value: String
      let symbol: String
      let color: Color

      static let all = Content(text: "All", value: "233", symbol: "tray.circle.fill", color: .red)
      static let uncleared = Content(text: "Uncleared", value: "0", symbol: "archivebox.circle.fill", color: .gray)
      static let repeating = Content(text: "Repeating", value: "20", symbol: "repeat.circle.fill", color: .yellow)
      static let flagged = Content(text: "Flagged", value: "66", symbol: "flag.circle.fill", color: .blue)
    }

    var content: Content {
      switch self {
      case .all:
        return Content.all
      case .uncleared:
        return Content.uncleared
      case .repeating:
        return Content.repeating
      case .flagged:
        return Content.flagged
      }
    }
  }

  struct MenuItem: View {
    let item: Item.Content

    var body: some View {
      VStack(alignment: .leading, spacing: 6) {
        HStack {
          Image(systemName: item.symbol).font(.title2).foregroundColor(item.color)
          Spacer()
          Text(item.value).font(.subheadline)
        }
        Text(item.text).font(.callout).fontWeight(.medium)
      }
      .padding(12)
      .background(.background)
      .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
  }
}

struct NavigationRow<Label, Destination> : View where Label : View, Destination : View {
  private let destination: Destination
  private let isActive: Binding<Bool>
  private let label: Label

  init(@ViewBuilder destination: () -> Destination, isActive: Binding<Bool>, @ViewBuilder label: () -> Label) {
    self.destination = destination()
    self.isActive = isActive
    self.label = label()
  }

  var body: some View {
    ZStack {
      label

      NavigationLink(destination: destination, isActive: isActive) {
        EmptyView()
      }
      .buttonStyle(.plain)
      .opacity(0)
    }
  }
}

extension EdgeInsets {
  static let `default` = EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 16)
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
