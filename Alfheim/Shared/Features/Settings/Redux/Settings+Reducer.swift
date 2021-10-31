//
//  Settings+Reducer.swift
//  Settings+Reducer
//
//  Created by alex.huo on 2021/9/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension AppReducers {
  enum Settings {
    static let reducer = Reducer<AppState.Settings, AppAction.Settings, AppEnvironment>.combine(
      Reducer { state, action, environment in
        switch action {
        case .sheet(let presented):
          state.isPresented = presented
        case .selectAppIcon(let icon):
          state.appIcon = icon
        }
        return .none
      }
    )
  }
}
