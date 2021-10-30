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
      struct FetchRequestId: Hashable {}
      switch action {
      case let .toggleFlag(flag, id):
        return AppEffects.Transaction.updateFlag(flag, with: id, context: environment.context)
          .replaceError(with: false)
          .ignoreOutput()
          .fireAndForget()
      case .delete(let id):
        return AppEffects.Transaction.delete(with: [id], in: environment.context)
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
}
