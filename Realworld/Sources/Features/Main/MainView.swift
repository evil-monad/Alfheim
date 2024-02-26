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
import Domain

public struct MainView: View {
  let store: StoreOf<App>
#if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif

  public init(store: StoreOf<App>) {
    self.store = store
  }

  public var body: some View {
#if os(iOS)
    if horizontalSizeClass == .compact {
      ListNavigation(store: store)
        .environment(\.defaultMinListHeaderHeight, 40)
    } else {
      SplitNavigation(store: store)
    }
#else
    SplitNavigation(store: store)
#endif
  }
}

/// iOS
struct ListNavigation: View {
  @Bindable var store: Store<App.State, App.Action>

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      ContentView(store: store)
        .task {
          store.send(.loadAll)
        }
    } destination: { store in
      switch store.case {
      case let .overview(store):
        OverviewView(store: store)
      case let .transation(store):
        TransactionList(store: store)
      }
    }
  }
}

struct ContentView: View {
  @Bindable var store: Store<App.State, App.Action>

  var body: some View {
    HomeView(store: store.scope(state: \.home, action: \.home))
      .listStyle(.insetGrouped)
      .navigationBarTitle("Clic")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            store.send(.newTransaction)
          } label: {
            Image(systemName: "plus.circle")
          }
        }
        ToolbarItemGroup(placement: .bottomBar) {
          HStack {
            Button {
              store.send(.main(.settings))
            } label: {
              Image(systemName: "gear")
            }
            Spacer()
            Button {
              store.send(.main(.newAccount))
            } label: {
              Text("Add Account")
            }
          }
        }
      }
      .sheet(
        item: $store.scope(
          state: \.main.destination?.newAccount,
          action: \.main.destination.newAccount
        )
      ) { store in
        EditAccountView(store: store, mode: .new)
      }
      .sheet(
        item: $store.scope(
          state: \.main.destination?.settings,
          action: \.main.destination.settings
        )
      ) { store in
        NavigationStack {
          SettingsView(store: store)
            .navigationTitle("Settings")
            .toolbar {
              ToolbarItem(placement: .cancellationAction) {
                Button {
                  self.store.send(.main(.dismiss))
                } label: {
                  Text("Done").bold()
                }
              }
            }
        }
      }
  }
}

#if DEBUG

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(
      store: AppStore(initialState: App.State()) {
        RealWorld()
      }
    )
  }
}

#endif
