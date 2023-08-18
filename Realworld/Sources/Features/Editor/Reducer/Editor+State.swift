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
import ComposableArchitecture
import Domain
import Database
import Persistence
import Kit

public struct Editor: Reducer {
  @Dependency(\.persistent) var persistent
  @Dependency(\.validator) var validator
}

extension Editor {
  /// Composer, editor state
  public struct State: Equatable {
    public enum Mode: Equatable {
      case new
      case edit(Domain.Transaction)

      var isNew: Bool {
        switch self {
        case .new:
          return true
        default:
          return false
        }
      }
    }

    public enum FocusField: Hashable {
      case amount
      case notes
      case payee
      case number
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

    var target: Domain.Account.Summary? = nil
    var source: Domain.Account.Summary? = nil
    var attachments: [Domain.Attachment] = []

    var accounts: [Domain.Account] = []

    var isValid: Bool = false
    var focusField: FocusField? = nil

    var isNew: Bool {
      return mode.isNew
    }
  }
}

extension Editor.State {
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
      // target = nil
      attachments = []
    case .edit(let transaction):
      amount = "\(transaction.amount)"
      currency = transaction.currency
      date = transaction.date
      notes = transaction.notes
      payee = transaction.payee
      number = transaction.number
      repeated = Repeat(rawValue: Int(transaction.repeated)) ?? .never
      cleared = transaction.cleared
      source = transaction.source
      target = transaction.target
      attachments = transaction.attachments
    }
    self.mode = mode
  }
}

extension Editor.State {
  var transaction: Domain.Transaction {
    switch mode {
    case .new:
      return Domain.Transaction(
        id: UUID(),
        amount: Double(amount)!,
        currency: Int16(currency.rawValue),
        date: date,
        notes: notes,
        payee: payee,
        number: number,
        repeated: Int16(repeated.rawValue),
        cleared: cleared,
        flagged: false,
        target: target!,
        source: source!,
        attachments: attachments
      )
    case .edit(let transaction):
      return Domain.Transaction(
        id: transaction.id,
        amount: Double(amount)!,
        currency: Int16(currency.rawValue),
        date: date,
        notes: notes,
        payee: payee,
        number: number,
        repeated: Int16(repeated.rawValue),
        cleared: cleared,
        flagged: false,
        target: target!,
        source: source!,
        attachments: attachments
      )
    }
  }

  var groupedRootAccounts: [String: [Domain.Account]] {
    return rootAccounts.grouped(by: { $0.group.rawValue })
  }

  var rootAccounts: [Domain.Account] {
    accounts.filter { $0.root }.flatMap { $0.children ?? [] }
  }
}

extension String {
  var isValidAmount: Bool {
    self != "" && Double(self) != nil
  }
}
