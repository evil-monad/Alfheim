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

enum Transactions {
  enum Filter: Equatable {
    case none
    case list(title: String, transactions: [Alfheim.Transaction])
    case accounted(account: Alfheim.Account, interval: DateInterval?)
  }
}

extension AppState {
  /// Transaction list view state
  struct Transaction: Equatable {
    private var filter: Transactions.Filter
    var sectionedTransactions: IdentifiedArrayOf<SectionedTransaction>

    init(filter: Transactions.Filter) {
      self.filter = filter

      let filteredTransactions: [Alfheim.Transaction]

      switch filter {
      case .none:
        filteredTransactions = []
      case let .list(_, transactions):
        filteredTransactions = transactions
      case let .accounted(account, interval):
        if let interval = interval {
          filteredTransactions = account.transactions(.with)
            .filter { interval.contains($0.date) }
        } else {
          filteredTransactions = account.transactions(.with)
        }
      }

      let sections = Dictionary(grouping: filteredTransactions) { transaction in
        return transaction.date.start(of: .day)
      }
      .map { SectionedTransaction(date: $0, transactions: $1) }
      .sorted(by: { $0.date > $1.date })

      self.sectionedTransactions = IdentifiedArray(uniqueElements: sections)
    }

    var title: String {
      switch filter {
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
