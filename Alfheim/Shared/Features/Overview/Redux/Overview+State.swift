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

    var balance: Double {
      let deposits = periodTransactions.filter { (account.isAncestor(of: $0.target) && $0.amount < 0) || (account.isAncestor(of: $0.source) && $0.amount >= 0) }
        .map { abs($0.amount) }
        .reduce(0.0, +)

      let withdrawal = periodTransactions.filter { (account.isAncestor(of: $0.target) && $0.amount >= 0 ) || (account.isAncestor(of: $0.source) && $0.amount < 0)  }
        .map { abs($0.amount) }
        .reduce(0.0, +)

      return deposits - withdrawal
    }

    var balanceText: String {
      let code = Alne.Currency(rawValue: Int(account.currency))!.code
      return balance.formatted(.currency(code: code))
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

  var statistics: [HistogramLabeledUnit] {
    return composition()
  }

  func composition() -> [HistogramLabeledUnit] {
    guard let children = account.children else {
      return []
    }

    let transfer: Account.Transfer
    if account.alne.group == .expenses {
      transfer = .deposit
    } else if account.alne.group == .income {
      transfer = .withdrawal
    } else {
      transfer = .all
    }

    let ret = children.sorted(by: { $0.amount(transfer: transfer) > $1.amount(transfer: transfer) })
      .map { ($0.name, abs($0.amount(transfer: transfer)), $0.emoji ?? "") }

    let otherAmount = account.amount(.only)
    guard otherAmount > 0 else {
      return ret
    }
    let other = ("others", otherAmount, account.emoji.orEmpty)
    return ret + [other]
  }

  func trend() {
    // 7 day
    // 1 month
  }
}
