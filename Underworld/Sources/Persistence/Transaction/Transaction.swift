//
//  Transaction+CoreData.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Database
import Domain

extension Domain.Transaction {
  public init?(_ entity: Database.Transaction) {
    guard let target = entity.target, let source = entity.source else {
      return nil
    }
    let attachments = entity.attachments?.compactMap(Domain.Attachment.init) ?? []
    self.init(
      id: entity.id,
      amount: entity.amount,
      currency: entity.currency,
      date: entity.date,
      notes: entity.notes,
      payee: entity.payee,
      number: entity.number,
      repeated: entity.repeated,
      cleared: entity.cleared,
      flagged: entity.flagged,
      target: Domain.Account.Summary(target),
      source: Domain.Account.Summary(source),
      attachments: attachments
    )
  }
}

public extension Database.Transaction {
  func fill(_ model: Domain.Transaction) {
    id = model.id
    amount = model.amount
    currency = model.currency.rawValue
    date = model.date
    notes = model.notes
    payee = model.payee
    number = model.number
    repeated = model.repeated
    cleared = model.cleared
    flagged = model.flagged
  }

  func fill(target: Database.Account) {
    self.target = target
  }

  func fill(source: Database.Account) {
    self.source = source
  }

  func fill(attachments: [Database.Attachment]) {
    self.attachments = Set(attachments)
  }
}

public extension Domain.Transaction {
  static func uniqued(_ transactions: [Domain.Transaction]) -> [Domain.Transaction] {
    var uniqueTransactions: [Domain.Transaction] = []
    var filter = Set<UUID>()
    for transaction in transactions {
      if !filter.contains(transaction.id) {
        uniqueTransactions.append(transaction)
        filter.insert(transaction.id)
      }
    }
    return uniqueTransactions
  }
}
