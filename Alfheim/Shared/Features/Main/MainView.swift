//
//  MainView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/19.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

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
          .onAppear {
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
        .navigationBarItems(
          trailing: Button(action: {
            vs.send(.cleanup)
          }) {
            Image(systemName: "gear")
          }
        )
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
          .onAppear {
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
        .navigationBarItems(
          trailing: Button(action: {
          vs.send(.cleanup)
        }) {
          Image(systemName: "gear")
        }
        )
    }
  }
}

struct Home: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(store) { vs in
      AccountList(accounts: vs.accounts.filter { $0.parent == nil })
    }
  }
}

struct AccountList: View {
  var accounts: [Account]

  var body: some View {
    List(accounts, children: \.optinalChildren) { account in
      ZStack {
        HStack {
          Text("\(account.emoji ?? "") \(account.name)")
          Spacer()
        }

        NavigationLink {
          OverviewView(
            store: Store(
              initialState: AppState.Overview(account: account),
              reducer: AppReducers.Overview.reducer,
              environment: AppEnvironment()
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
}

#if DEBUG
//struct MainView_Previews: PreviewProvider {
//  static var previews: some View {
//    MainView().environmentObject(AppStore(moc: viewContext))
//  }
//}
#endif
