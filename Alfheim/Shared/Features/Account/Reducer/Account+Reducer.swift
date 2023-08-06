//
//  AppReducer+Account.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Persistence

struct Account: Reducer {
  @Dependency(\.persistent) var persistent

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .update(let account):
        return .run { _ in
          try await persistent.update(account)
          try await persistent.sync(item: account, keyPath: \.parent, to: account.parent)
        }
      }
    }
  }
}
