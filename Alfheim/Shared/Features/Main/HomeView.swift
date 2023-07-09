//
//  HomeView.swift
//  Alfheim
//
//  Created by alex.huo on 2022/12/5.
//  Copyright © 2022 blessingsoft. All rights reserved.
//

import SwiftUI
import Domain
import ComposableArchitecture

struct HomeView: View {
  let store: Store<App.State, App.Action>

  var body: some View {
    WithViewStore(store.scope(state: \.homeState, action: { $0 })) { vs in
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
          OutlineGroup(vs.rootAccounts, children: \.children) { account in
            AccountRow(store: store, account: account)
              .contextMenu(account.root ? nil : ContextMenu {
                Button {
                  vs.send(.account(presenting: true, account))
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
        .sheet(isPresented: vs.binding(get: \.selectAccount, send: { App.Action.account(presenting: $0, nil) })) {
          EditAccountView(
            store: store.scope(
              state: \.editAccount,
              action: App.Action.editAccount),
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
//struct AccountList: View {
//  let store: Store<AppState, AppAction>
//  let accounts: [Account]
//
//  var body: some View {
//    List(accounts, children: \.children) { account in
//      AccountRow(store: store, account: account)
//    }
//  }
//}

private struct AccountRow: View {
  let store: Store<App.State, App.Action>
  let account: Domain.Account

  var body: some View {
    ZStack {
      HStack {
        Text("\(account.emoji ?? "") \(account.name)")
        Spacer()
      }
      WithViewStore(store, observe: { $0 }) { vs in
        NavigationLink(state: App.Path.State.overview(Overview.State(account: account))) {
          EmptyView()
        }
        .buttonStyle(.plain)
        .opacity(account.hasChildren ? 0: 1)
      }
    }
  }
}

struct QuickMenu: View {
  let store: Store<App.State, App.Action>
  private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 18), count: 2)

  var body: some View {
    WithViewStore(store, observe: { $0.home }) { vs in
      LazyVGrid(columns: columns, spacing: 18) {
        ForEach(vs.menus) { item in
          MenuRow(item: item, isSelected: vs.selection?.id == item.id)
            .onTapGesture {
              vs.send(.selectMenu(item))
            }
        }
      }
      .onLongPressGesture {}
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
          // selection = nil
          vs.send(.selectMenu(nil))
        }
      }
    }
  }
}

struct MenuRow: View {
  let item: Home.MenuItem
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
    .background(Color(UIColor.secondarySystemGroupedBackground))
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
  }
}

extension EdgeInsets {
  static let `default` = EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 16)
}

extension Home.MenuItem {
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

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Section(header: EmptyView()) {
        QuickMenu(store: AppStore(initialState: App.State(), reducer: RealWorld())).listRowBackground(Color.clear)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())

      Section(header: Text("Accounts").font(.headline).foregroundColor(.primary)) {
        Text("ABC")
      }
    }.listStyle(.insetGrouped)
  }
}

#endif
