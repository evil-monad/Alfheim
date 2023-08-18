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
  let store: Store<App.State, App.Action>

  var body: some View {
    WithViewStore(store, observe: { $0.main }) { vs in
      HomeView(store: store.scope(state: \.home, action: { .home($0) }))
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

struct SplitDetail: View {
  let store: Store<App.State, App.Action>

  var body: some View {
    WithViewStore(store, observe: { $0.detail }) { vs in
      IfLetStore(store.scope(state: \.detail, action: { .detail($0) })) { store in
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
          SwitchStore(store) { state in
            switch state {
            case .overview:
              CaseLet(
                /App.Detail.State.overview,
                 action: App.Detail.Action.overview,
                 then: OverviewView.init(store:)
              )
            case .transation:
              CaseLet(
                /App.Detail.State.transation,
                 action: App.Detail.Action.transation,
                 then: TransactionList.init(store:)
              )
            }
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
      } else: {
        Text("No selection")
      }
    }
  }
}
