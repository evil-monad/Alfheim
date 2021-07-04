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

struct TransactionViewState: Identifiable {
  let transaction: Alfheim.Transaction

  let tag: Alne.Tagit

  let id: String

  let title: String
  let source: String
  let target: String
  let deposit: Bool

  let amount: Double
  let currency: Currency

  let date: Date
}

extension TransactionViewState {
  init(transaction: Alfheim.Transaction, tag: Alne.Tagit, deposit: Bool = true) {
    self.transaction = transaction
    self.id = transaction.id.uuidString
    self.tag = tag

    self.title = transaction.payee.map { "@\($0)" } ?? transaction.notes
    self.source = "\(transaction.source?.emoji ?? "")\(transaction.source?.name ?? "")"
    self.target = "\(transaction.target?.emoji ?? "")\(transaction.target?.name ?? "")"
    self.deposit = deposit

    self.amount = transaction.amount
    self.currency = Currency(rawValue: Int(transaction.currency)) ?? .cny

    self.date = transaction.date
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
}

extension TransactionViewState {
  static func mock(cxt: NSManagedObjectContext) -> TransactionViewState {
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

    return TransactionViewState(transaction: transaction, tag: .alfheim)
  }
}
