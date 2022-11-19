//
//  Settings+Reducer.swift
//  Settings+Reducer
//
//  Created by alex.huo on 2021/9/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct Settings: ReducerProtocol {
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .sheet(let presented):
      state.isPresented = presented
    case .selectAppIcon(let icon):
      state.appIcon = icon
    }
    return .none
  }
}
