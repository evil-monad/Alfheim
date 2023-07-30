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
import CoreData

extension Domain.Attachment: FetchedResult {
  public static func fetchRequest() -> NSFetchRequest<Database.Attachment> {
    Database.Attachment.fetchRequest()
  }
}

extension Domain.Attachment {
  public init?(from entity: Database.Attachment) {
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

  public static func decode(from entity: Database.Attachment) -> Domain.Attachment? {
    self.init(from: entity)
  }

  public static func map(_ entities: [Database.Attachment]) -> [Domain.Attachment] {
    entities.compactMap(Domain.Attachment.init)
  }

  public func encode(to context: NSManagedObjectContext) -> Database.Attachment {
    let object = Database.Attachment(context: context)
    object.fill(self)
    return object
  }
}


public extension Database.Attachment {
  func fill(_ model: Domain.Attachment) {
    id = model.id
    thumbnail = nil
    url = model.url.absoluteString
  }
}
