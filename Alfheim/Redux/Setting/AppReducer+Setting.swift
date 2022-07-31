//
//  AppReducer+Setting.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppReducers {
  enum Settings {
    static func reduce(state: AppState, action: AppAction.Settings) -> (AppState, AppCommand?) {
      var appState = state
      var appCommand: AppCommand? = nil

      switch action {
      case .togglePayment:
        appState.settings.isPaymentEnabled.toggle()

      case .selectIcon(let icon):
        appCommand = AppCommands.ChangeAppIconCommand(currentIcon: state.settings.appIcon, selectedIcon: icon)
        appState.settings.appIcon = icon
      case .selectIconDone(let icon, let result):
        switch result {
        case .success:
          break
        case .failure(let error):
          appState.settings.appIcon = icon
          print("Change app icon failed: \(error)")
        }
      }

      return (appState, appCommand)
    }
  }
}
