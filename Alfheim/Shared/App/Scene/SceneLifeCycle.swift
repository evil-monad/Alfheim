//
//  SceneLifeCycle.swift
//  Alfheim
//
//  Created by alex.huo on 2021/11/20.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

enum SceneLifecycleEvent: Equatable {
  case willConnect
  case didDisconnect
  case willResignActive
  case didBecomeActive
  case willEnterForeground
  case didEnterBackground
}
