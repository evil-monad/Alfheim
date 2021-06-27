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
  struct Editor: Equatable {
    enum Mode: Equatable {
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

    var mode: Mode = .new
    var amount: String = ""
    var currency: Currency = .cny

    var date: Date = Date()
    var notes: String = ""
    var payee: String?
    var number: String?

    var repeated: Repeat = .never
    var cleared: Bool = true

    var target: Alfheim.Account? = nil
    var source: Alfheim.Account? = nil
    var attachments: [Alfheim.Attachment] = []

    var accounts: [Alfheim.Account] = []

    var isValid: Bool = false

    var isNew: Bool {
      return mode.isNew
    }
  }
}

extension AppState.Editor {
  mutating func reset(_ mode: Mode) {
    switch mode {
    case .new:
      amount = ""
      currency = .cny
      date = Date()
      notes = ""
      payee = nil
      number = nil
      repeated = .never
      cleared = true
      source = nil
      target = nil
      attachments = []
    case .edit(let transaction):
      amount = "\(transaction.amount)"
      currency = Currency(rawValue: Int(transaction.currency)) ?? .cny
      date = transaction.date
      notes = transaction.notes
      payee = transaction.payee
      number = transaction.number
      repeated = Repeat(rawValue: Int(transaction.repeated)) ?? .never
      cleared = transaction.cleared
      source = transaction.source
      target = transaction.target
      attachments = transaction.attachments?.allObjects as? [Attachment] ?? []
    }
    self.mode = mode
  }
}

extension AppState.Editor {
  var transaction: Alfheim.Transaction.Snapshot {
    let snapshot: Alfheim.Transaction.Snapshot
    switch mode {
    case .new:
      snapshot = Alfheim.Transaction.Snapshot(
        amount: Double(amount)!,
        currency: Int16(currency.rawValue),
        date: date,
        notes: notes,
        target: target!,
        source: source!
      )
    case .edit(let transaction):
      transaction.amount = Double(amount)!
      transaction.currency = Int16(currency.rawValue)
      transaction.date = date
      transaction.notes = notes
      transaction.payee = payee
      transaction.number = number
      transaction.repeated = Int16(repeated.rawValue)
      transaction.cleared = cleared
      transaction.target = target
      transaction.source = source
      transaction.attachments = NSSet(objects: attachments)
      snapshot = Alfheim.Transaction.Snapshot(transaction)
    }
    return snapshot
  }

  var groupedAccounts: [String: [Alfheim.Account]] {
    return accounts.grouped(by: { $0.group })
  }

  var rootAccounts: [Alfheim.Account] {
    accounts.filter { $0.root }
  }
}

extension String {
  var isValidAmount: Bool {
    self != "" && Double(self) != nil
  }
}
