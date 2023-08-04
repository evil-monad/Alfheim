//
//  AppState+Overview.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import Alne
import Persistence
import ComposableArchitecture

extension Overview {
  /// Overview view state
  struct State: Equatable, Identifiable {
    var isEditorPresented: Bool = false
    var isStatisticsPresented: Bool = false
    var selectedTransaction: Domain.Transaction?
    var editingTransaction: Bool = false
    var isAccountDetailPresented: Bool = false
    var isSettingsPresented: Bool = false
    var isOnboardingPresented: Bool = false

    var editor: Editor.State
    var transactions: Transaction.State
    var timeInterval: DateInterval?

    var id: UUID
    var account: Domain.Account

    init(account: Domain.Account) {
      print("init \(account.name)")
      self.account = account
      self.id = account.id
      self.editor = Editor.State(target: account.summary)
      let interval: DateInterval?
      switch account.group {
      case .income, .expenses:
        let now = Date()
        interval = DateInterval(start: now.start(of: .month), end: now.end(of: .month))
      default:
        interval = nil
      }
      self.timeInterval = interval
      self.transactions = Transaction.State(source: .accounted(account: account, interval: interval))
    }

    private var allTransactions: [Domain.Transaction] {
      account.transactions()
    }

    private var periodTransactions: [Domain.Transaction] {
      if let timeInterval = timeInterval {
        return allTransactions
          .filter { $0.date >= timeInterval.start && $0.date <= timeInterval.end }
      } else {
        return allTransactions
      }
    }

    var periodText: String {
      timeInterval?.start.formatted(.dateTime.month()) ?? ""
    }

    var balance: Double {
      let deposits = periodTransactions.filter { (account.summary.isAncestor(of: $0.target) && $0.amount < 0) || (account.summary.isAncestor(of: $0.source) && $0.amount >= 0) }
        .map { abs($0.amount) }
        .reduce(0.0, +)

      let withdrawal = periodTransactions.filter { (account.summary.isAncestor(of: $0.target) && $0.amount >= 0 ) || (account.summary.isAncestor(of: $0.source) && $0.amount < 0)  }
        .map { abs($0.amount) }
        .reduce(0.0, +)

      return deposits - withdrawal
    }

    var balanceText: String {
      let code = account.currency.code
      return balance.formatted(.currency(code: code))
    }
  }
}

// Recent transaction
extension Overview.State {
  var showRecentTransactionsSection: Bool {
    return !recentTransactions.isEmpty
  }

  // prefix 5
  var recentTransactions: [Domain.Transaction] {
    Array(allTransactions.sorted(by: { $0.date > $1.date }).prefix(5))
  }
}

extension Overview.State {
  struct ContentState: Equatable {
    var accountName: String
    var isRootAccount: Bool
    var showRecentTransactionsSection: Bool
    var showStatisticsSection: Bool
    var showCompositonStatistics: Bool
    var isEditorPresented: Bool
  }

  var contentState: ContentState {
    get {
      ContentState(
        accountName: account.name,
        isRootAccount: account.root,
        showRecentTransactionsSection: showRecentTransactionsSection,
        showStatisticsSection: showStatisticsSection,
        showCompositonStatistics: showCompositonStatistics,
        isEditorPresented: isEditorPresented
      )
    }
    set {
      isEditorPresented = newValue.isEditorPresented
    }
  }
}

extension Overview.State {
  struct TransactionState: Equatable {
    var recentTransactions: [Domain.Transaction]
    var account: Domain.Account
  }

  var transactionState: TransactionState {
    get {
      TransactionState(recentTransactions: recentTransactions, account: account)
    }
    set {
    }
  }
}

// Stat
extension Overview.State {
  var showStatisticsSection: Bool {
    return showTrendStatistics || showCompositonStatistics
  }

  var showCompositonStatistics: Bool {
    let validAccount = account.children?.filter { !$0.transactions().isEmpty } ?? []
    return !validAccount.isEmpty
  }

  var compositonUnit: [(name: String, value: Double, symbol: String, tagit: Tagit)] {
    guard let children = account.children else {
      return []
    }

    let transfer: Domain.Account.Transfer
    if account.group == .expenses {
      transfer = .deposit
    } else if account.group == .income {
      transfer = .withdrawal
    } else {
      transfer = .all
    }

    let ret = children.sorted(by: { $0.amount(transfer: transfer) > $1.amount(transfer: transfer) })
      .map { (name: $0.name, value: abs($0.amount(transfer: transfer)), symbol: $0.emoji.orEmpty, tagit: $0.tagit) }

    let otherAmount = account.amount(.current)
    guard otherAmount > 0 else {
      return ret
    }
    let other = (name: "others", value: otherAmount, symbol: account.emoji.orEmpty, tagit: account.tagit)
    return ret + [other]
  }

  var showTrendStatistics: Bool {
    return account.group.balance
  }

  // recent 6 month
  // TODO: shoule use total balance, not month amount
  var trendUnit: [(name: String, value: Double)] {
    let now = Date()
    return (0..<6).reversed().compactMap { delta in
      guard let month = Calendar.current.date(byAdding: .month, value: -delta, to: now) else {
        return nil
      }
      let start = month.start(of: .month)
      let end = month.end(of: .month)

      let transactions = allTransactions
        .filter { $0.date >= start && $0.date <= end }
      let balances = Persistence.balances(account: account, transactions: transactions)
      let name = start.formatted(.dateTime.month())
      return (name: name, value: balances)
    }
  }
}
