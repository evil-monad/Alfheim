//
//  AppReducer+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension AppReducers {
  enum Transaction {
    static let reducer = Reducer<AppState.Transaction, AppAction.Transaction, AppEnvironment> { state, action, environment in
      return .none
    }
  }
}
