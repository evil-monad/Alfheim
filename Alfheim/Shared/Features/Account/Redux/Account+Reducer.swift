//
//  AppReducer+Account.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture

extension AppReducers {
  enum Account {
    static let reducer = Reducer<AppState.Account, AppAction.Account, AppEnvironment> { state, action, environment in
      switch action {
      case .update(let account):
        ()
      }
      return .none
    }
  }
}
