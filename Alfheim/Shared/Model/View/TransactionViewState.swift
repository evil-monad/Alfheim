//
//  TransactionViewState.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/14.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

enum Transfer {
  case `in`
  case out
}

extension Transactions {
  struct ViewState: Equatable, Identifiable {
    let transaction: Alfheim.Transaction

    let tag: Alne.Tagit

    let id: UUID

    let title: String
    let source: String
    let target: String
    let deposit: Bool

    let amount: Double
    let currency: Currency

    let date: Date
    let flagged: Bool
  }
}

extension Transactions.ViewState {
  init(transaction: Alfheim.Transaction, tag: Alne.Tagit, deposit: Bool = true) {
    self.transaction = transaction
    self.id = transaction.id
    self.tag = tag

    self.title = transaction.payee.map { "@\($0)" } ?? transaction.notes
    self.source = transaction.source?.fullName ?? ""
    self.target = transaction.target?.fullName ?? ""
    self.deposit = deposit

    self.amount = transaction.amount
    self.currency = Currency(rawValue: Int(transaction.currency)) ?? .cny

    self.date = transaction.date
    self.flagged = transaction.flagged
  }

  var forward: Bool {
    if deposit {
      return amount >= 0
    } else {
      return amount < 0
    }
  }

  var from: String {
    deposit ? target : source
  }

  var to: String {
    deposit ? source : target
  }

  var displayAmount: String {
    // let style = FloatingPointFormatStyle.Currency(code: currency.code, locale: Locale.current) Locale.autoupdatingCurrent
    let amount = forward ? -abs(transaction.amount) : abs(transaction.amount)
    return amount.formatted(.currency(code: currency.code).precision(.fractionLength(1)).sign(strategy: .always()))
  }
}

extension Transactions.ViewState {
  static func mock(cxt: NSManagedObjectContext) -> Transactions.ViewState {
    let transaction = Alfheim.Transaction(context: cxt)
    transaction.id = UUID()
    transaction.amount = 23.0
    transaction.currency = Int16(Currency.cny.rawValue)

    transaction.date = Date(timeIntervalSince1970: 1582726132.0)
    transaction.notes = "Apple"
    transaction.payee = "McDonalds"
    transaction.number = "233"
    transaction.repeated = 0
    transaction.cleared = true

    let source = Alfheim.Account(context: cxt)
    source.currency = Int16(Currency.cny.rawValue)
    source.emoji = "🍉"
    source.introduction = "Assets"
    source.name = "Checking"
    source.group = "Assets"
    source.id = UUID()

    let target = Alfheim.Account(context: cxt)
    target.currency = Int16(Currency.cny.rawValue)
    target.emoji = "💵"
    target.introduction = "Income"
    target.name = "Salary"
    target.group = "Income"
    target.id = UUID()

    transaction.source = source
    transaction.target = target

    return Transactions.ViewState(transaction: transaction, tag: .alfheim)
  }
}
