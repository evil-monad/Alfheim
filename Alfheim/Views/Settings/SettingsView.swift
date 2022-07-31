//
//  SettingsView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/25.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

//struct SettingsView: View {
//  @Environment(\.presentationMode) var presentationMode
//  @EnvironmentObject var store: AppStore
//
//  private var state: AppState.Settings {
//    store.state.settings
//  }
//  private var binding: Binding<AppState.Settings> {
//    $store.state.settings
//  }
//
//  var body: some View {
//    NavigationView {
//      List {
//        Section(header: Spacer()) {
//          Toggle(isOn: binding.isPaymentEnabled) {
//            Text("Enable Payment").fontWeight(.medium)
//          }
//          if state.isPaymentEnabled {
//            NavigationLink(destination: PaymentList()) {
//              Text("Payments").fontWeight(.medium)
//            }
//          }
//          NavigationLink(destination: CatemojiView()) {
//            Text("Catemojis").fontWeight(.medium)
//          }
//          NavigationLink(destination: CloudSettingView()) {
//            Text("Cloud").fontWeight(.medium)
//          }
//        }
//
//        Section {
//          NavigationLink(destination: AppearanceView()) {
//            Text("Dark Mode").fontWeight(.medium)
//          }
//          NavigationLink(destination: AppIconSettingView()) {
//            Text("App Icon").fontWeight(.medium)
//          }
//        }
//
//        Section {
//         NavigationLink(destination: HelpView()) {
//            Text("Help").fontWeight(.medium)
//          }
//          HStack {
//            Text("Version").fontWeight(.medium)
//            Spacer()
//            Text(state.appVersion)
//          }
//        }
//      }
//      .listStyle(InsetGroupedListStyle())
//      .navigationBarTitle("Settings")
//      .navigationBarItems(
//        leading: Button(action: {
//          self.presentationMode.wrappedValue.dismiss()
//        }) {
//          Text("Done").bold()
//      })
//    }
//  }
//}
//
//#if DEBUG
//struct SettingsView_Previews: PreviewProvider {
//  static var previews: some View {
//    SettingsView()
//  }
//}
//#endif
