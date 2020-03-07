//
//  AppState.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine

struct AppState {
  var shared: Shared
  var overview = Overview()
  var transactions = TransactionList()
  var editor = Editor()
  var settings = Settings()
  // shared global state

  var accountDetail: AccountDetail

  init() {
    let account = Alne.Accounts.expenses
    let transactions = Alne.Transactions.samples()
    shared = Shared(account: account, allTransactions: transactions)
    accountDetail = AccountDetail(account: account)
  }
}

extension AppState {
  /// Transaction period
  enum Period {
    case weekly
    case montly
    case yearly

    var display: String {
      switch self {
      case .weekly:
        return "this week"
      case .montly:
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
    var period: Period = .montly
    /// this should be latest selected sorting
    var sorting: Sorting = .date

    var allTransactions: [Alne.Transaction]

    var periodTransactions: [Alne.Transaction] {
      let current = Date()
      let startDate: Date
      switch period {
      case .weekly:
        startDate = current.start(of: .week)
      case .montly:
        startDate = current.start(of: .month)
      case .yearly:
        startDate = current.start(of: .year)
      }

      return allTransactions
        .filter { $0.date >= startDate }
    }

    var displayTransactions: [Alne.Transaction] {
      let sortBy: (Alne.Transaction, Alne.Transaction) -> Bool
      switch sorting {
      case .date:
        sortBy = { $0.date > $1.date }
      case .currency:
        sortBy = { $0.currency.rawValue < $1.currency.rawValue }
      }

      return periodTransactions
        .sorted(by: sortBy)
    }

    var amount: Double {
      periodTransactions
        .map { $0.amount }
        .reduce(0.0, +)
    }

    var amountText: String {
      "\(account.currency.symbol)\(amount)"
    }
  }
}

extension AppState {
  /// Overview view state
  struct Overview {
    var isEditorPresented: Bool = false
    var isStatisticsPresented: Bool = false
    var selectedTransaction: Alne.Transaction?
    var editingTransaction: Bool = false
    var isAccountDetailPresented: Bool = false

    var transactions: [Alne.Transaction] {
      Alne.Transactions.samples()
    }

    func displayTransactions(with period: Period, sorting: Sorting) -> [Alne.Transaction] {
      let current = Date()
      let startDate: Date
      switch period {
      case .weekly:
        startDate = current.start(of: .week)
      case .montly:
        startDate = current.start(of: .month)
      case .yearly:
        startDate = current.start(of: .year)
      }

      let sortBy: (Alne.Transaction, Alne.Transaction) -> Bool
      switch sorting {
      case .date:
        sortBy = { $0.date > $1.date }
      case .currency:
        sortBy = { $0.currency.rawValue < $1.currency.rawValue }
      }

      return transactions
        .filter { $0.date >= startDate }
        .sorted(by: sortBy)
    }
  }
}

extension AppState {
  /// Transaction list view state
  struct TransactionList {
  }
}

extension AppState {
  /// Composer, editor state
  struct Editor {
    enum Mode {
      case new
      case edit(Alne.Transaction)
    }

    class Validator {
      @Published var amount: String = ""
      @Published var currency: Currency = .cny
      @Published var emoji: Catemoji = Catemoji.fruit(.apple)
      @Published var date: Date = Date()
      @Published var notes: String = ""
      @Published var payment: String = "Pay"

      var mode: Mode = .new

      func reset(_ mode: Mode) {
        switch mode {
        case .new:
          amount = ""
          currency = .cny
          emoji = Catemoji.fruit(.apple)
          date = Date()
          notes = ""
          payment = "Pay"
        case .edit(let transaction):
          amount = "\(transaction.amount)"
          currency = transaction.currency
          emoji = transaction.catemoji
          date = transaction.date
          notes = transaction.notes
          payment = transaction.payment ?? "Pay"
        }
        self.mode = mode
      }

      var isAmountValid: AnyPublisher<Bool, Never> {
        $amount.map { $0.isValidAmount }
          .eraseToAnyPublisher()
      }

      var isNotesValid: AnyPublisher<Bool, Never> {
        $notes.map { $0 != "" }
          .eraseToAnyPublisher()
      }

      var isValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isAmountValid, isNotesValid).map { $0 && $1 }
          .eraseToAnyPublisher()
      }

      var transaction: Alne.Transaction {
        switch mode {
        case .new:
          return Alne.Transaction(date: date,
                             amount: Double(amount)!,
                             catemoji: emoji,
                             notes: notes,
                             currency: currency)
        case .edit(let transaction):
          return Alne.Transaction(id: transaction.id,
                             date: date,
                             amount: Double(amount)!,
                             catemoji: emoji,
                             notes: notes,
                             currency: currency)
        }
      }
    }

    var validator = Validator()
    var isValid: Bool = false
  }
}

extension String {
  var isValidAmount: Bool {
    self != "" && Double(self) != nil
  }
}

extension AppState {
  /// Account detail view state
  struct AccountDetail {
    /// editing account
    var account: Alne.Account
  }
}

extension AppState {
  struct Settings {
    var isPaymentEnabled = true
  }
}
