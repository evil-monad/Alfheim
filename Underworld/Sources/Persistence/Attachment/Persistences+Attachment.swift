//
//  Persistences+Attachment.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData
import Database

public extension Persistences {
  struct Attachment {
    let context: NSManagedObjectContext

    typealias FetchRequestPublisher = Publishers.FetchRequest<Database.Attachment>

    // MARK: - Operators, CURD

    /// Fetch with predicate, should use in context queue
    func fetch(with predicate: NSPredicate) throws -> [Database.Attachment] {
      let fetchRequest: NSFetchRequest<Database.Attachment> = Database.Attachment.fetchRequest()
      fetchRequest.predicate = predicate
      return try context.fetch(fetchRequest)
    }

    /// Save if has changes, should use in context.perform(_:) block if you need to update results, if not, update notification won't be send to
    /// subscriber, NSFetchedResultsController for example.
    func save() throws {
      guard context.hasChanges else {
        return
      }
      try context.save()
    }

    /// Delete, without save.
    func delete(_ object: NSManagedObject) {
      context.delete(object)
    }

    // MARK: - Publishes
  }
}
