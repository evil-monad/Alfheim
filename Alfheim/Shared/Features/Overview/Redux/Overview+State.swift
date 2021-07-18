//
//  AppState+Overview.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppState {
  /// Overview view state
  struct Overview: Equatable, Identifiable {
    var isEditorPresented: Bool = false
    var isStatisticsPresented: Bool = false
    var selectedTransaction: Alfheim.Transaction?
    var editingTransaction: Bool = false
    var isAccountDetailPresented: Bool = false
    var isSettingsPresented: Bool = false
    var isOnboardingPresented: Bool = false

    var isTransactionListActive = false

    var account: Alfheim.Account
    var period: Period = .yearly

    var editor = Editor()

    var id: UUID

    init(account: Alfheim.Account) {
      print("init")
      self.account = account
      self.id = account.id
      self.editor = Editor(target: account)
    }

    var transactions: [Alfheim.Transaction] {
      account.transactions
    }

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

      return transactions
        .filter { $0.date >= startDate }
    }

    var amount: Double {
      let deposits = periodTransactions.filter { ($0.target == account && $0.amount < 0) || ($0.source == account && $0.amount >= 0) }
        .map { abs($0.amount) }
        .reduce(0.0, +)

      let withdrawal = periodTransactions.filter { ($0.target == account && $0.amount >= 0 ) || ($0.source == account && $0.amount < 0)  }
        .map { abs($0.amount) }
        .reduce(0.0, +)

      return deposits - withdrawal
    }

    var amountText: String {
      let code = Alne.Currency(rawValue: Int(account.currency))!.code
      return amount.formatted(.currency(code: code))
    }
  }
}

// Recent transaction
extension AppState.Overview {
  var showRecentTransactionsSection: Bool {
    return !recentTransactions.isEmpty
  }

  // prefix 5
  var recentTransactions: [Alfheim.Transaction] {
    Array(transactions.prefix(5))
  }
}

// Stat
extension AppState.Overview {
  var showStatisticsSection: Bool {
    return (account.children?.count ?? 0) >= 1
  }

  var statistics: [(String, Double, String)] {
    guard let children = account.children else {
      return []
    }

    return children.map { ($0.name, $0.amount, $0.emoji ?? "") }
  }
}
