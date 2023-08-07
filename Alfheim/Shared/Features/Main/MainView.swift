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

struct MainView: View {
  let store: Store<App.State, App.Action>
  #if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  #endif

  var body: some View {
    #if os(iOS)
    if horizontalSizeClass == .compact {
      ListNavigation(store: store)
        .environment(\.defaultMinListHeaderHeight, 40)
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
  let store: Store<App.State, App.Action>

  var body: some View {
    NavigationView {
      Sidebar(store: store)
        .task {
          store.send(.loadAll)
        }
      // detail view in iPad
      Text("Sidebar navigation")
    }
  }
}

struct Sidebar: View {
  let store: Store<App.State, App.Action>

  var body: some View {
    HomeView(store: store)
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
              //vs.send(.cleanup)
              store.send(.settings(.sheet(isPresented: true)))
            } label: {
              Image(systemName: "gear")
            }
            Spacer()
            Button {
              store.send(.addAccount(presenting: true))
            } label: {
              Text("Add Account")
            }
          }
        }
      }
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
    WithViewStore(store, observe: { $0.contentState }) { vs in
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
        .sheet(isPresented: vs.binding(get: \.isAccountComposerPresented, send: App.Action.addAccount)) {
          EditAccountView(
            store: store.scope(
              state: \.editAccount,
              action: App.Action.editAccount),
            mode: .new
          )
        }
        .sheet(
          isPresented: vs.binding(get: \.isSettingsPresented, send: { .settings(.sheet(isPresented: $0)) })
        ) {
          SettingsView(
            store: store.scope(
              state: \.settings,
              action: App.Action.settings
            )
          )
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
