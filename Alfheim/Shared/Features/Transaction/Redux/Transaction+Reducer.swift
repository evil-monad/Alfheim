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
      case .fetch:
        return AppEffects.Transaction.fetch(environment: environment)
          .cancellable(id: FetchRequestId())
      case .didChange(let transactions):
        guard !transactions.isEmpty else {
          return .none
        }
        // don't access filteredTransactions, delete transaction will cause EXC_BAD_INSTRUCTION
        return .none
      case .flag(let transaction):
        transaction.flagged = !transaction.flagged
        return AppEffects.Transaction.save(in: environment.context)
          .replaceError(with: false)
          .ignoreOutput()
          .fireAndForget()

      case .delete(let transaction):
        return AppEffects.Transaction.delete(transactions: [transaction], in: environment.context)
          .replaceError(with: false)
          .ignoreOutput()
          .fireAndForget()
      default:
        break
      }
      return .none
    }
  }
}
