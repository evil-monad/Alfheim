//
//  AppIconSettingView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/25.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct AppIconSettingView: View {
  @EnvironmentObject var store: AppStore

  private var state: AppState.Settings {
    store.state.settings
  }
  private var binding: Binding<AppState.Settings> {
    $store.state.settings
  }

  var body: some View {
    List(AppIcon.allCases) { icon in
      HStack(spacing: 10) {
        Image(uiImage: UIImage(named: icon.icon) ?? UIImage())
          .cornerRadius(13.36)
          .overlay(
            RoundedRectangle(cornerRadius: 13.36)
              .stroke(Color.primary.opacity(0.1), lineWidth: 0.5))
          .shadow(color: Color.primary.opacity(0.1), radius: 4)

        Text(icon.name)
        Spacer()
        if icon == self.state.appIcon {
          Image(systemName: "checkmark")
            .font(Font.body.bold())
            .foregroundColor(.blue)
        }
      }
      .padding(.vertical, 12)
      .contentShape(Rectangle())
      .onTapGesture {
        self.store.dispatch(.settings(.selectIcon(icon)))
      }
    }
    .navigationBarTitle("App Icon")
  }
}

struct AppIconSettingView_Previews: PreviewProvider {
  static var previews: some View {
    AppIconSettingView()
  }
}
