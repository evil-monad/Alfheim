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

enum Transactions {
  enum Filter: Equatable {
    case none
    case list(title: String, transactions: [Alfheim.Transaction])
    case accounted(account: Alfheim.Account, interval: DateInterval)
  }
}

extension AppState {
  /// Transaction list view state
  struct Transaction: Equatable {
    var filter: Transactions.Filter

    var title: String {
      switch filter {
      case .none: return ""
      case .list(let title, _):
        return title
      case .accounted(account: let account, _):
        return account.name
      }
    }

    var filteredTransactions: [Alfheim.Transaction] {
      switch filter {
      case .none:
        return []
      case let .list(_, transactions):
        return transactions
      case let .accounted(account, interval):
        return account.transactions(.with)
          .filter { interval.contains($0.date) }
      }
    }

    var sectionedTransactions: [Date: [Alfheim.Transaction]] {
      return Dictionary(grouping: filteredTransactions) { transaction in
        return transaction.date.start(of: .day)
      }
    }
  }
}
