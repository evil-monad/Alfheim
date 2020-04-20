//
//  AppState+Editor.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
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
      @Published var emoji: Catemojis = Catemojis.uncleared(.uncleared)
      @Published var date: Date = Date()
      @Published var notes: String = ""
      //@Published var payment: Alfheim.Payment? = nil
      @Published var payment: Int = 0

      var payments: [Alfheim.Payment] = []
      var defaultPayment: Alfheim.Payment?
      var mode: Mode = .new

      func reset(_ mode: Mode) {
        switch mode {
        case .new:
          amount = ""
          currency = .cny
          emoji = Catemojis.uncleared(.uncleared)
          date = Date()
          notes = ""
          payment = 0
        case .edit(let transaction):
          amount = "\(transaction.amount)"
          currency = Currency(rawValue: Int(transaction.currency)) ?? .cny
          emoji = transaction.emoji.map { Catemojis($0) } ?? .uncleared(.uncleared)
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
        newTransaction.category = emoji.category
        newTransaction.emoji = emoji.emoji
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
                                                  category: emoji.category,
                                                  emoji: emoji.emoji,
                                                  notes: notes,
                                                  payment: pm)
        case .edit(let transaction):
          transaction.date = date
          transaction.amount = Double(amount)!
          transaction.category = emoji.category
          transaction.emoji = emoji.emoji
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
