//
//  SceneLifecycle.swift
//  Alfheim
//
//  Created by alex.huo on 2023/8/1.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Persistence

public struct SceneLifecycle: Reducer {
  @Dependency(\.persistent) var persistent

  public struct State: Equatable {}

  public enum Action: Equatable {
    case willConnect
    case didDisconnect
    case willResignActive
    case didBecomeActive
    case willEnterForeground
    case didEnterBackground
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .willConnect:
        return .run { _ in
          try await persistent.bootstrap()
        }
      case .didEnterBackground:
        return .run { send in
          persistent.save()
        }
      default:
        return .none
      }
    }
  }
}
