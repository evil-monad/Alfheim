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

extension AppState {
  /// Transaction list view state
  struct Transaction: Equatable, Identifiable {
    private(set) var source: Transactions.Source

    let id: String
    var filter: Filter = .none

    var sectionedTransactions: IdentifiedArrayOf<SectionedTransaction>

    init(source: Transactions.Source) {
      self.source = source

      switch source {
      case .none:
        id = UUID().uuidString
      case .list(title: let title, _):
        id = title
      case .accounted(account: let account, _):
        id = account.id.uuidString
      }

      let filteredTransactions: [Alfheim.Transaction] = source.filteredTransactions

      let sections = Dictionary(grouping: filteredTransactions) { transaction in
        return transaction.date.start(of: .day)
      }
      .map { SectionedTransaction(date: $0, transactions: $1) }
      .sorted(by: { $0.date > $1.date })

      self.sectionedTransactions = IdentifiedArray(uniqueElements: sections)
    }

    var title: String {
      switch source {
      case .none: return ""
      case .list(let title, _):
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

    var filteredSectionedTransactions: IdentifiedArrayOf<SectionedTransaction> {
      let filteredTransactions: [Alfheim.Transaction]
      switch filter {
      case .none:
        filteredTransactions = source.filteredTransactions
      case .week:
        let timeInterval: DateInterval = Date().interval(of: .week)
        filteredTransactions = source.allTransactions.filter { timeInterval.contains($0.date) }
      case .month:
        let timeInterval: DateInterval = Date().interval(of: .week)
        filteredTransactions = source.allTransactions.filter { timeInterval.contains($0.date) }
      case .year:
        let timeInterval: DateInterval = Date().interval(of: .week)
        filteredTransactions = source.allTransactions.filter { timeInterval.contains($0.date) }
      case .all:
        filteredTransactions = source.allTransactions
      }

      let sections = Dictionary(grouping: filteredTransactions) { transaction in
        return transaction.date.start(of: .day)
      }.map { AppState.Transaction.SectionedTransaction(date: $0, transactions: $1) }
      .sorted(by: { $0.date > $1.date })

      return IdentifiedArray(uniqueElements: sections)
    }

    struct SectionedTransaction: Equatable, Identifiable {
      var id: Date {
        return date
      }
      let date: Date
      //private let transactions: [Alfheim.Transaction]
      let viewStates: IdentifiedArrayOf<Transactions.ViewState>

      init(date: Date, transactions: [Alfheim.Transaction]) {
        self.date = date
        //self.transactions = transactions
        self.viewStates = IdentifiedArray(uniqueElements: transactions.map { Transactions.ViewState(transaction: $0, tag: Tagit.alfheim, deposit: false, ommitedDate: true) })
      }
    }
  }
}

enum Transactions {
  enum Source: Equatable {
    case none
    case list(title: String, transactions: [Alfheim.Transaction])
    case accounted(account: Alfheim.Account, interval: DateInterval?)

    var filteredTransactions: [Alfheim.Transaction] {
      switch self {
      case .none:
        return []
      case let .list(_, transactions):
        return transactions
      case let .accounted(account, interval):
        if let interval = interval {
          return account.transactions(.with)
            .filter { interval.contains($0.date) }
        } else {
          return account.transactions(.with)
        }
      }
    }

    var allTransactions: [Alfheim.Transaction] {
      switch self {
      case .none:
        return []
      case let .list(_, transactions):
        return transactions
      case let .accounted(account, _):
        return account.transactions(.with)
      }
    }
  }
}

extension AppState.Transaction {
  enum Filter: LocalizedStringKey, CaseIterable, Hashable {
    case none = "None"
    case week = "This Week"
    case month = "This Month"
    case year = "This Year"
    case all = "All"

    var name: LocalizedStringKey {
      rawValue
    }
  }
}
