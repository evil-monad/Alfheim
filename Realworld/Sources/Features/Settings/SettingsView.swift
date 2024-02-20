//
//  SettingsView.swift
//  SettingsView
//
//  Created by alex.huo on 2021/9/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Kit

struct SettingsView: View {
  let store: Store<Settings.State, Settings.Action>

  var body: some View {
    List {
      Section {
        NavigationLink {
          CloudView()
        } label: {
          Text("Cloud")
        }
      }

      Section {
        NavigationLink {
          AppearanceView()
        } label: {
          Text("Appearance")
        }

        NavigationLink {
          AppIconView(store: store)
        } label: {
          Text("App Icon")
        }
      }

      Section {
        NavigationLink {
          AboutView()
        } label: {
          Text("About")
        }

        NavigationLink {
          HelpView()
        } label: {
          Text("Help")
        }

        HStack {
          Text("Version")
          Spacer()
          Text(store.appVersion)
        }
      }
    }
    .listStyle(.insetGrouped)
    .fontWeight(.regular)
  }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(
      store: Store(
        initialState: Settings.State(isPresented: false, appIcon: .primary)
      ) {
          Settings()
        }
    )
  }
}
#endif
