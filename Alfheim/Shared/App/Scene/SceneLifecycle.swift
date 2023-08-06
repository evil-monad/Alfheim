//
//  SceneLifecycle.swift
//  Alfheim
//
//  Created by alex.huo on 2023/8/1.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct SceneLifecycle: Reducer {
  struct State: Equatable {}

  enum Action: Equatable {
    case willConnect
    case didDisconnect
    case willResignActive
    case didBecomeActive
    case willEnterForeground
    case didEnterBackground
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
