//
//  Transaction.swift
//  Domain
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

public struct Transaction: Equatable, Identifiable {
  public let id: UUID
  public var amount: Double
  public var currency: Currency

  public var date: Date
  public var notes: String
  public var payee: String?
  public var number: String?

  public var repeated: Int16
  public var cleared: Bool
  public var flagged: Bool

  // relationship
  public var target: Account.Summary
  public var source: Account.Summary
  public var attachments: [Attachment]

  public init(
    id: UUID,
    amount: Double,
    currency: Currency,
    date: Date,
    notes: String,
    payee: String?,
    number: String?,
    repeated: Int16,
    cleared: Bool,
    flagged: Bool,
    target: Account.Summary,
    source: Account.Summary,
    attachments: [Attachment]
  ) {
    self.id = id
    self.amount = amount
    self.currency = currency
    self.date = date
    self.notes = notes
    self.payee = payee
    self.number = number
    self.repeated = repeated
    self.cleared = cleared
    self.flagged = flagged
    self.target = target
    self.source = source
    self.attachments = attachments
  }
}

extension Transaction {
  public init(
    id: UUID,
    amount: Double,
    currency: Int16,
    date: Date,
    notes: String,
    payee: String?,
    number: String?,
    repeated: Int16,
    cleared: Bool,
    flagged: Bool,
    target: Account.Summary,
    source: Account.Summary,
    attachments: [Attachment]
  ) {
    self.id = id
    self.amount = amount
    self.currency = Currency(rawValue: currency)!
    self.date = date
    self.notes = notes
    self.payee = payee
    self.number = number
    self.repeated = repeated
    self.cleared = cleared
    self.flagged = flagged
    self.target = target
    self.source = source
    self.attachments = attachments
  }
}

extension Transaction: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

public extension Transaction {
  var summary: Transaction.Summary {
    Transaction.Summary(
      id: id,
      amount: amount,
      currency: currency,
      date: date,
      notes: notes,
      payee: payee,
      number: number,
      repeated: repeated,
      cleared: cleared,
      flagged: flagged
    )
  }
}
