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
    Home(store: store)
      .listStyle(SidebarListStyle())
      .navigationBarTitle("Clic")
      .navigationBarItems(
        trailing: Button(action: {
          //viewStore.send(.cleanup)
        }) {
          Image(systemName: "gear")
        }
      )
//      .sheet(
//        isPresented: binding.isSettingsPresented,
//        onDismiss: {
//          self.store.dispatch(.overview(.toggleSettings(presenting: false)))
//      }) {
//        SettingsView()
//      }
//      .toolbar(content: {
//        ToolbarItem(placement: .primaryAction) {
//          Button(action: {
//            //store.dispatch(.cleanup)
//          }) {
//            Label("Settings", systemImage: "gear")
//          }
//        }
//      })
//    }
  }
}

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
    Home(store: store)
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle("Clic")
      .navigationBarItems(
        trailing: Button(action: {
          //viewStore.send(.cleanup)
        }) {
          Image(systemName: "gear")
        }
      )
  }
}

struct Home: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      List {
        ForEachStore(
          self.store.scope(
            state: \.overviews,
            action: AppAction.overview
          )
        ) { overviewStore in
          WithViewStore(overviewStore) { viewStore in
            DisclosureGroup(
              isExpanded: .constant(true),
              content: {
                NavigationLink(
                  destination:
                    OverviewView(store: overviewStore)
                ) {
                  Text("\(viewStore.account.emoji ?? "") \(viewStore.account.name)")
                }
              },
              label: {
                Label(viewStore.account.name, systemImage: "folder.circle")
              })
          }
        }
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
