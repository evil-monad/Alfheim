//
//  AppReducer+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain

extension Transaction {
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      struct FetchRequestId: Hashable {}

      switch action {
      case let .toggleFlag(flag, id):
        return .run { send in
          let transaction: Domain.Transaction = try await persistent.update(id, keyPath: \Domain.Transaction.ResultType.flagged, value: flag)
        }
      case .delete(let transaction):
        return .run { send in
          try await persistent.delete(transaction)
        }
      case .filter(let selection):
        state.filter = selection
      default:
        break
      }
      return .none
    }
  }
}
