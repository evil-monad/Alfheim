//
//  TransactionViewState.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/14.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import Alne
import Persistence

enum Transfer {
  case `in`
  case out
}

extension Transactions {
  struct ViewState: Equatable, Identifiable {
    let transaction: Domain.Transaction

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

    let ommitedDate: Bool
  }
}

extension Transactions.ViewState {
  init(transaction: Domain.Transaction, tag: Alne.Tagit, deposit: Bool = true, ommitedDate: Bool = false) {
    self.transaction = transaction
    self.id = transaction.id
    self.tag = tag

    self.title = transaction.payee.map { "@\($0)" } ?? transaction.notes
    self.source = transaction.source.fullName
    self.target = transaction.target.fullName
    self.deposit = deposit

    self.amount = transaction.amount
    self.currency = transaction.currency

    self.date = transaction.date
    self.flagged = transaction.flagged

    self.ommitedDate = ommitedDate
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
  static func mock() -> Transactions.ViewState {
    let source = Domain.Account.Summary(
      id: UUID(),
      name: "Checking",
      introduction: "Assets",
      group: .assets,
      currency: .cny,
      tag: "Tag",
      emoji: "🍉",
      descendants: nil,
      ancestors: nil
    )

    let target = Domain.Account.Summary(
      id: UUID(),
      name: "Salary",
      introduction: "Income",
      group: .income,
      currency: .cny,
      tag: "Salary",
      emoji: "💵",
      descendants: nil,
      ancestors: nil
    )

    let transaction = Domain.Transaction(
      id: UUID(),
      amount: 23.0,
      currency: .cny,
      date: Date(timeIntervalSince1970: 1582726132.0),
      notes: "Apple",
      payee: "McDonalds",
      number: "233",
      repeated: 0,
      cleared: true,
      flagged: true,
      target: target,
      source: source,
      attachments: [])

    return Transactions.ViewState(transaction: transaction, tag: .alfheim)
  }
}
