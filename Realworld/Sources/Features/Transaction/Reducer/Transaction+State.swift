//
//  AppState+Transaction.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData
import Combine
import IdentifiedCollections
import SwiftUI // LocalizedStringKey
import Domain
import ComposableArchitecture
import Alne
import Persistence

@Reducer
public struct Transaction {
  @Dependency(\.persistent) var persistent

  public enum Action: Equatable {
    case editTransaction(Domain.Transaction)
    case didEditTransaction

    case delete(Domain.Transaction)
    case toggleFlag(Domain.Transaction)
    case showStatistics([Domain.Transaction], interval: DateInterval)
    case dimissStatistics

    case filtered(Transaction.State.Filter)

    case onAppear

    case transactionsDidChange([Domain.Transaction])
    case accountDidChange(Domain.Account)
  }


  /// Transaction list view state
  @ObservableState
  public struct State: Equatable, Identifiable {
    var source: Transactions.Source

    public let id: String
    var filter: Filter = .none

    init(source: Transactions.Source) {
      self.source = source

      switch source {
      case .none:
        id = UUID().uuidString
      case .list(let title, _, _):
        id = title
      case .accounted(account: let account, _):
        id = account.id.uuidString
      }
    }

    var title: String {
      switch source {
      case .none: return ""
      case .list(let title, _, _):
        return title
      case let .accounted(_, interval):
        if let interval = interval {
          if Calendar.autoupdatingCurrent.isDate(interval.start, equalTo: interval.end.advanced(by: -0.0001), toGranularity: .month) {
            // the same month
            return "\(interval.start.formatted(.dateTime.month(.wide).year()))"
          } else {
            return "Transactions"
          }
        } else {
          return "All Transactions"
        }
      }
    }

    var isFilterEnabled: Bool {
      return source != .none
    }

    var filteredTransactions: IdentifiedArrayOf<SectionedTransaction> {
      let filteredTransactions: [Domain.Transaction]
      switch filter {
      case .none:
        filteredTransactions = source.filteredTransactions
      case .week:
        let timeInterval: DateInterval = Date().interval(of: .week)
        filteredTransactions = source.allTransactions.filter { timeInterval.contains($0.date) }
      case .month:
        let timeInterval: DateInterval = Date().interval(of: .month)
        filteredTransactions = source.allTransactions.filter { timeInterval.contains($0.date) }
      case .year:
        let timeInterval: DateInterval = Date().interval(of: .year)
        filteredTransactions = source.allTransactions.filter { timeInterval.contains($0.date) }
      case .all:
        filteredTransactions = source.allTransactions
      }

      let sections = Dictionary(grouping: filteredTransactions) { transaction in
          return transaction.date.start(of: .day)
        }
        .map { Transaction.State.SectionedTransaction(date: $0, transactions: $1) }
        .sorted(by: { $0.date > $1.date })

      return IdentifiedArray(uniqueElements: sections)
    }

    struct SectionedTransaction: Equatable, Identifiable {
      var id: Date {
        return date
      }
      let date: Date
      let viewStates: IdentifiedArrayOf<Transactions.ViewState>

      init(date: Date, transactions: [Domain.Transaction]) {
        self.date = date
        self.viewStates = IdentifiedArray(uniqueElements: transactions.sorted(by: { $0.date > $1.date })
          .map { Transactions.ViewState(transaction: $0, tag: Tagit.alfheim, deposit: false, ommitedDate: true) })
      }
    }

    public enum Filter: LocalizedStringKey, CaseIterable, Hashable {
      case none = "None" // default transaction source, not equals to all
      case week = "This Week"
      case month = "This Month"
      case year = "This Year"
      case all = "All"

      public var name: LocalizedStringKey {
        rawValue
      }
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      struct FetchRequestId: Hashable {}

      switch action {
      case .onAppear:
        var effects = [Effect<Action>]()
        effects.append(
          .run { send in
            let stream: AsyncStream<[Domain.Transaction]> = persistent.observe(
              Domain.Transaction.all.sort("date", ascending: false),
              fetch: false
            )
            for try await transactions in stream {
              await send(.transactionsDidChange(transactions))
            }
          }
        )
        if case let .accounted(account, _) = state.source {
          effects.append(
            .run { send in
              let stream: AsyncStream<[Domain.Account]> = persistent.observe(
                Domain.Account.all.where(Domain.Account.identifier == account.id),
                fetch: false,
                relationships: Domain.Account.relationships) { accounts in
                  if let observed = accounts.first {
                    return Domain.Account.makeTree(root: observed)
                  } else {
                    return []
                  }
                }
              for try await accounts in stream where !accounts.isEmpty {
                assert(accounts.count == 1 && accounts.first!.id == account.id)
                if let observed = accounts.first {
                  await send(.accountDidChange(observed))
                }
              }
            }
          )
        }
        return .merge(effects)
      case .transactionsDidChange(let transactions):
        switch state.source {
        case let .list(title, _, filter):
          state.source = .list(title: title, transactions: transactions.filtered(by: filter), filter: filter)
          return .none
        default:
          return .none
        }
      case .accountDidChange(let account):
        switch state.source {
        case .accounted(_, let interval):
          state.source = .accounted(account: account, interval: interval)
        default:
          return .none
        }
      case .toggleFlag(let transaction):
        return .run { send in
          try await persistent.update(transaction, keyPath: \Domain.Transaction.ResultType.flagged, value: !transaction.flagged)
        }
      case .delete(let transaction):
        return .run { send in
          try await persistent.delete(transaction)
        }
      case .filtered(let selection):
        state.filter = selection
      default:
        break
      }
      return .none
    }
  }
}

enum Transactions {
  enum Source: Equatable {
    case none
    case list(title: String, transactions: [Domain.Transaction], filter: Domain.Transaction.Filter = .all)
    case accounted(account: Domain.Account, interval: DateInterval?)

    var filteredTransactions: [Domain.Transaction] {
      switch self {
      case .none:
        return []
      case let .list(_, transactions, filter):
        return transactions.filtered(by: filter)
      case let .accounted(account, interval):
        if let interval = interval {
          return account.transactions(.depth)
            .filter { interval.contains($0.date) }
        } else {
          return account.transactions(.depth)
        }
      }
    }

    var allTransactions: [Domain.Transaction] {
      switch self {
      case .none:
        return []
      case let .list(_, transactions, filter):
        return transactions.filtered(by: filter)
      case let .accounted(account, _):
        return account.transactions(.depth)
      }
    }
  }
}
