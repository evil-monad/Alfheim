//
//  SettingsView.swift
//  SettingsView
//
//  Created by alex.huo on 2021/9/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
  let store: Store<Settings.State, Settings.Action>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { vs in
      List {
        Section {
          NavigationLink {
            CloudView()
          } label: {
            Text("Cloud").fontWeight(.medium)
          }
        }

        Section {
          NavigationLink {
            AppearanceView()
          } label: {
            Text("Appearance").fontWeight(.medium)
          }

          NavigationLink {
            AppIconView(store: store)
          } label: {
            Text("App Icon").fontWeight(.medium)
          }
        }

        Section {
          NavigationLink {
            AboutView()
          } label: {
            Text("About").fontWeight(.medium)
          }

          NavigationLink {
            HelpView()
          } label: {
            Text("Help").fontWeight(.medium)
          }

          HStack {
            Text("Version").fontWeight(.medium)
            Spacer()
            Text(vs.appVersion)
          }
        }
      }
      .listStyle(.insetGrouped)
    }
  }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(
      store: Store(
        initialState: Settings.State(isPresented: false, appIcon: .primary)) {
          Settings()
        }
      )
  }
}
#endif
