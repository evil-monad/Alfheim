//
//  AppState.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

/*
struct AppState {
  //var shared: Shared
  var overview = Overview()
  var transactions = TransactionList()
  var editor = Editor()
  var settings = Settings()
  var payment = Payment()
  var catemoji = Catemoji()
  // var statistics: Statistics
  // shared global state

  //var accountDetail: AccountDetail

  var accounts = [Alfheim.Account]()

  var selection: Alfheim.Account?

  

//  init() {
//    let account = Alne.Accounts.expenses
//    shared = Shared(account: account, allPayments: [], allTransactions: [])
//    accountDetail = AccountDetail(account: account)
//    statistics = Statistics(account: account)
//  }
}

extension AppState {
  mutating func selectAccount(_ account: Alfheim.Account) {
    //shared = Shared(account: account, allPayments: [], allTransactions: [])
    //accountDetail = AccountDetail(account: account)
    //statistics = Statistics(account: account)
  }
}

extension AppState {
  /// Transaction period
  enum Period {
    case weekly
    case monthly
    case yearly

    var display: String {
      switch self {
      case .weekly:
        return "this week"
      case .monthly:
        return "this month"
      case .yearly:
        return "this year"
      }
    }
  }

  enum Sorting: CaseIterable {
    case date
    case currency
  }
}

extension AppState {
  /// Shared global state
  struct Shared {
    var account: Alne.Account
    /// this should be latest selected period
    var period: Period = .monthly
    /// this should be latest selected sorting
    var sorting: Sorting = .date

    var allPayments: [Alfheim.Payment]

    var allTransactions: [Alfheim.Transaction]

    var periodTransactions: [Alfheim.Transaction] {
      let current = Date()
      let startDate: Date
      switch period {
      case .weekly:
        startDate = current.start(of: .week)
      case .monthly:
        startDate = current.start(of: .month)
      case .yearly:
        startDate = current.start(of: .year)
      }

      return allTransactions
        .filter { $0.date >= startDate }
    }

    var displayTransactions: [TransactionViewModel] {
      let sortBy: (Alfheim.Transaction, Alfheim.Transaction) -> Bool
      switch sorting {
      case .date:
        sortBy = { $0.date > $1.date }
      case .currency:
        sortBy = { $0.currency < $1.currency }
      }

      return periodTransactions
        .sorted(by: sortBy)
        .map { TransactionViewModel(transaction: $0, tag: account.tag) }
    }

    var amount: Double {
      periodTransactions
        .map { $0.amount }
        .reduce(0.0, +)
    }

    var amountText: String {
      "\(account.currency.symbol)\(String(format: "%.2f", amount))"
    }

    var timeRange: DateInterval {
      let current = Date()

      switch period {
      case .weekly:
        return current.interval(of: .week)!
      case .monthly:
        return current.interval(of: .month)!
      case .yearly:
        return current.interval(of: .year)!
      }
    }
  }
}

extension Date: Strideable {
  public func distance(to other: Date) -> TimeInterval {
    return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
  }

  public func advanced(by n: TimeInterval) -> Date {
    return self + n
  }
}
*/
