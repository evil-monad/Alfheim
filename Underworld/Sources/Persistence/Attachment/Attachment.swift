//
//  Attachment.swift
//  Alfheim
//
//  Created by alex.huo on 2021/1/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import Database

extension Domain.Attachment {
  public init?(_ entity: Database.Attachment) {
    guard let string = entity.url, let url = URL(string: string), let transaction = entity.transaction else {
      return nil
    }
    self.init(
      id: entity.id,
      thumbnail: URL(string: "")!,
      url: url,
      transaction: Domain.Transaction.Summary(transaction)
    )
  }
}
