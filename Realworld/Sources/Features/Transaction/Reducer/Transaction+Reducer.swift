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
import Persistence

extension Transaction {
//  public var body: some ReducerOf<Self> {
//    Reduce { state, action in
//      struct FetchRequestId: Hashable {}
//
//      switch action {
//      case .onAppear:
//        var effects = [Effect<Action>]()
//        effects.append(
//          .run { send in
//            let stream: AsyncStream<[Domain.Transaction]> = persistent.observe(
//              Domain.Transaction.all.sort("date", ascending: false),
//              fetch: false
//            )
//            for try await transactions in stream {
//              await send(.transactionsDidChange(transactions))
//            }
//          }
//        )
//        if case let .accounted(account, _) = state.source {
//          effects.append(
//            .run { send in
//              let stream: AsyncStream<[Domain.Account]> = persistent.observe(
//                Domain.Account.all.where(Domain.Account.identifier == account.id),
//                fetch: false,
//                relationships: Domain.Account.relationships) { accounts in
//                  if let observed = accounts.first {
//                    return Domain.Account.makeTree(root: observed)
//                  } else {
//                    return []
//                  }
//                }
//              for try await accounts in stream where !accounts.isEmpty {
//                assert(accounts.count == 1 && accounts.first!.id == account.id)
//                if let observed = accounts.first {
//                  await send(.accountDidChange(observed))
//                }
//              }
//            }
//          )
//        }
//        return .merge(effects)
//      case .transactionsDidChange(let transactions):
//        switch state.source {
//        case let .list(title, _, filter):
//          state.source = .list(title: title, transactions: transactions.filtered(by: filter), filter: filter)
//          return .none
//        default:
//          return .none
//        }
//      case .accountDidChange(let account):
//        switch state.source {
//        case .accounted(_, let interval):
//          state.source = .accounted(account: account, interval: interval)
//        default:
//          return .none
//        }
//      case .toggleFlag(let transaction):
//        return .run { send in
//          try await persistent.update(transaction, keyPath: \Domain.Transaction.ResultType.flagged, value: !transaction.flagged)
//        }
//      case .delete(let transaction):
//        return .run { send in
//          try await persistent.delete(transaction)
//        }
//      case .filtered(let selection):
//        state.filter = selection
//      default:
//        break
//      }
//      return .none
//    }
//  }
}
