//
//  AppState+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData

extension AppState {
  /// Composer, editor state
  struct Editor {
    enum Mode {
      case new
      case edit(Transaction)

      var isNew: Bool {
        switch self {
        case .new:
          return true
        default:
          return false
        }
      }
    }

    class Validator {
      @Published var amount: String = ""
      @Published var currency: Currency = .cny
      @Published var catemoji: Alne.Catemoji = Alne.Catemoji(category: .uncleared, emoji: Alne.Uncleared.uncleared.emoji)
      @Published var date: Date = Date()
      @Published var notes: String = ""
      @Published var payment: Int = 0

      var payments: [Alfheim.Payment] = []
      var mode: Mode = .new

      func reset(_ mode: Mode) {
        switch mode {
        case .new:
          amount = ""
          currency = .cny
          catemoji = Alne.Catemoji(category: .uncleared, emoji: Alne.Uncleared.uncleared.emoji)
          date = Date()
          notes = ""
          payment = 0
        case .edit(let transaction):
          amount = "\(transaction.amount)"
          currency = Currency(rawValue: Int(transaction.currency)) ?? .cny
          if let value = transaction.category, let category = Category(rawValue: value), let emoji = transaction.emoji {
            catemoji = Alne.Catemoji(category: category, emoji: emoji)
          } else {
            catemoji = Alne.Catemoji.uncleared
          }
          date = transaction.date
          notes = transaction.notes
          if let payment = transaction.payment,
            let index = payments.firstIndex(of: payment) {
            self.payment = index
          } else {
            self.payment = 0
          }
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

      func transaction(context: NSManagedObjectContext) -> Alfheim.Transaction {
        let newTransaction: Alfheim.Transaction
        switch mode {
        case .new:
          newTransaction = Alfheim.Transaction(context: context)
          newTransaction.id = UUID()
        case .edit(let transaction):
          newTransaction = transaction
        }

        newTransaction.date = date
        newTransaction.amount = Double(amount)!
        newTransaction.category = catemoji.category.rawValue
        newTransaction.emoji = catemoji.emoji
        newTransaction.notes = notes
        newTransaction.currency = Int16(currency.rawValue)
        newTransaction.payment = payments.count > payment ? payments[payment] : nil
        return newTransaction
      }

      var transaction: Alfheim.Transaction.Snapshot {
        let pm = payments.count > payment ? payments[payment] : nil
        let snapshot: Alfheim.Transaction.Snapshot
        switch mode {
        case .new:
          snapshot = Alfheim.Transaction.Snapshot(date: date,
                                                  amount: Double(amount)!,
                                                  currency: Int16(currency.rawValue),
                                                  category: catemoji.category.rawValue,
                                                  emoji: catemoji.emoji,
                                                  notes: notes,
                                                  payment: pm)
        case .edit(let transaction):
          transaction.date = date
          transaction.amount = Double(amount)!
          transaction.category = catemoji.category.rawValue
          transaction.emoji = catemoji.emoji
          transaction.notes = notes
          transaction.currency = Int16(currency.rawValue)
          transaction.payment = pm
          snapshot = Alfheim.Transaction.Snapshot(transaction)        }
        return snapshot
      }
    }

    var validator = Validator()
    var isValid: Bool = false

    var payments: [Alfheim.Payment] = [] {
      didSet {
        validator.payments = payments
      }
    }

    var catemojis: [Category: [Alne.Catemoji]] = [:]
    
    var isNew: Bool {
      return validator.mode.isNew
    }
  }
}

extension String {
  var isValidAmount: Bool {
    self != "" && Double(self) != nil
  }
}
