//
//  Transaction+Summary.swift
//  Alfheim
//
//  Created by alex.huo on 2021/11/14.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Database
import Domain

extension Domain.Transaction.Summary {
  init?(_ entity: Database.Transaction) {
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
      flagged: entity.flagged
    )
  }
}
