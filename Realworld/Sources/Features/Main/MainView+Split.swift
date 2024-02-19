//
//  MainView+Split.swift
//  Alfheim
//
//  Created by alex.huo on 2023/8/13.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import CoreMedia
import Domain

/// iPad & Mac
struct SplitNavigation: View {
  let store: Store<App.State, App.Action>

  var body: some View {
    NavigationSplitView {
      Sidebar(store: store)
        .task {
          store.send(.loadAll)
        }
    } detail: {
      SplitDetail(store: store)
        .onAppear {
          store.send(.sidebar)
        }
    }
  }
}

struct Sidebar: View {
  @Bindable var store: Store<App.State, App.Action>

  var body: some View {
    HomeView(store: store.scope(state: \.home, action: \.home))
      .listStyle(.insetGrouped)
      .tint(Color(UIColor.systemGray4))
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

struct SplitDetail: View {
  @Bindable var store: StoreOf<App>

  var body: some View {
    if let detail = store.scope(state: \.detail, action: \.detail) {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        Group {
          switch detail.state {
          case .overview:
            if let store = detail.scope(state: \.overview, action: \.overview) {
              OverviewView(store: store)
            }
          case .transation:
            if let store = detail.scope(state: \.transation, action: \.transation) {
              TransactionList(store: store)
            }
          }
        }
      } destination: { store in
        switch store.case {
        case let .overview(store):
          OverviewView(store: store)
        case let .transation(store):
          TransactionList(store: store)
        }
      }
    } else {
      Text("No selection")
    }
  }
}
