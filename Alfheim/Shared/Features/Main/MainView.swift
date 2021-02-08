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
//    #if os(iOS)
//    if horizontalSizeClass == .compact {
//      OverviewView()
//    } else {
//      SidebarNavigation()
//    }
//    #else
    SidebarNavigation(store: store)
//    #endif
  }
}

struct SidebarNavigation: View {
  #if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  #endif

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
    WithViewStore(store) { viewStore in
      List {
        ForEachStore(
          self.store.scope(
            state: \.overviews,
            action: AppAction.overview
          )
        ) { overviewStore in
          WithViewStore(overviewStore) { viewStore in
            NavigationLink(
              destination:
                OverviewView(store: overviewStore)
            ) {
              Label(viewStore.account.name, systemImage: "folder.circle")
            }
          }
        }
      }
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