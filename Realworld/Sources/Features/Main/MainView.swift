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
  let store: Store<App.State, App.Action>

  var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
      ContentView(store: store)
        .task {
          store.send(.loadAll)
        }
    } destination: {
      switch $0 {
      case .overview:
        CaseLet(
          /App.Path.State.overview,
          action: App.Path.Action.overview,
          then: OverviewView.init(store:)
        )
      case .transation:
        CaseLet(
          /App.Path.State.transation,
          action: App.Path.Action.transation,
          then: TransactionList.init(store:)
        )
      }
    }
  }
}

struct ContentView: View {
  let store: Store<App.State, App.Action>

  var body: some View {
    WithViewStore(store, observe: { $0.main }) { vs in
      HomeView(store: store.scope(state: \.home, action: { .home($0) }))
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
                vs.send(.main(.settings))
              } label: {
                Image(systemName: "gear")
              }
              Spacer()
              Button {
                vs.send(.main(.newAccount))
              } label: {
                Text("Add Account")
              }
            }
          }
        }
        .sheet(
          store: store.scope(state: \.main.$destination, action: { .main(.destination($0)) }),
          state: /Main.Destination.State.newAccount,
          action: Main.Destination.Action.newAccount
        ) { store in
          EditAccountView(store: store, mode: .new)
        }
        .sheet(
          store: store.scope(state: \.main.$destination, action: { .main(.destination($0)) }),
          state: /Main.Destination.State.settings,
          action: Main.Destination.Action.settings
        ) { store in
          NavigationStack {
            SettingsView(store: store)
              .navigationTitle("Settings")
              .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                  Button {
                    vs.send(.main(.dismiss))
                  } label: {
                    Text("Done").bold()
                  }
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
