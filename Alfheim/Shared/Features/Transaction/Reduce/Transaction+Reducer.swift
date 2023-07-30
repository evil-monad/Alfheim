//
//  AppReducer+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension Transaction {
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    struct FetchRequestId: Hashable {}

    switch action {
    case let .toggleFlag(flag, id):
      return Transaction.Effects.updateFlag(flag, with: id, context: persistent.context)
        .replaceError(with: false)
        .ignoreOutput()
        .fireAndForget()
    case .delete(let id):
      return Transaction.Effects.delete(with: [id], in: persistent.context)
        .replaceError(with: false)
        .ignoreOutput()
        .fireAndForget()
    case .filter(let selection):
      state.filter = selection
    default:
      break
    }
    return .none
  }
}
