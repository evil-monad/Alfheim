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
      account.transactions()
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
      let deposits = periodTransactions.filter { (account.isAncestor(of: $0.target) && $0.amount < 0) || (account.isAncestor(of: $0.source) && $0.amount >= 0) }
        .map { abs($0.amount) }
        .reduce(0.0, +)

      let withdrawal = periodTransactions.filter { (account.isAncestor(of: $0.target) && $0.amount >= 0 ) || (account.isAncestor(of: $0.source) && $0.amount < 0)  }
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
    Array(transactions.sorted(by: { $0.date > $1.date }).prefix(5))
  }
}

// Stat
extension AppState.Overview {
  var showStatisticsSection: Bool {
    let validAccount = account.children?.filter { !$0.transactions().isEmpty } ?? []
    return !validAccount.isEmpty
  }

  var statistics: [(String, Double, String)] {
    guard let children = account.children else {
      return []
    }

    return children.sorted(by: { $0.amount > $1.amount })
      .map { ($0.name, $0.amount, $0.emoji ?? "") }
  }
}
