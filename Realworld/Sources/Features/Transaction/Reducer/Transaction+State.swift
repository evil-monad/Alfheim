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

public struct Transaction: Reducer {
  @Dependency(\.persistent) var persistent
}

extension Transaction {
  /// Transaction list view state
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
      }.map { Transaction.State.SectionedTransaction(date: $0, transactions: $1) }
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

public extension Transaction.State {
  enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case none = "None" // default transaction source, not equals to all
    case week = "This Week"
    case month = "This Month"
    case year = "This Year"
    case all = "All"

    var name: LocalizedStringKey {
      rawValue
    }
  }
}
