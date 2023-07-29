//
//  Persistences+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/8.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData
import Database
import Domain

public struct Transaction {
  public let context: NSManagedObjectContext

  public typealias FetchRequestPublisher = Publishers.FetchRequest<Database.Transaction>

  public init(context: NSManagedObjectContext) {
    self.context = context
  }

  // MARK: - CURD

  /// Save if has changes, should use in context.perform(_:) block if you need to update results, if not, update notification won't be send to
  /// subscriber, NSFetchedResultsController for example.
  public func save() throws {
    guard context.hasChanges else {
      return
    }
    try context.save()
  }

  /// Delete, without save.
  public func delete(_ object: NSManagedObject) {
    context.delete(object)
  }

  public func transaction(withID id: UUID) -> Database.Transaction? {
    let predicate = NSPredicate(format: "id == %@", id as CVarArg)
    guard let object = context.registeredObjects(Database.Transaction.self, with: predicate).first else {
      return nil
    }
    return object
  }

  // MARK: - Publishes

  public func fetchRequestPublisher(sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)],
                             predicate: NSPredicate? = nil) -> FetchRequestPublisher {
    let fetchRequest: NSFetchRequest<Database.Transaction> = Database.Transaction.fetchRequest()
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.predicate = predicate
    return Publishers.FetchRequest(fetchRequest: fetchRequest, context: context)
  }

  public func fetchAllPublisher() -> AnyPublisher<[Database.Transaction], NSError> {
    fetchRequestPublisher()
      .eraseToAnyPublisher()
  }

  public func fetchPublisher(with predicate: NSPredicate) -> AnyPublisher<[Database.Transaction], NSError> {
    fetchRequestPublisher(predicate: predicate)
      .eraseToAnyPublisher()
  }

  public func fetchPublisher(withName name: String) -> AnyPublisher<Database.Transaction, NSError> {
    let predicate = NSPredicate(format: "name == %@", name)
    return fetchPublisher(with: predicate).compactMap { $0.first }
      .eraseToAnyPublisher()
  }

  public func fetchPublisher(withID id: UUID) -> AnyPublisher<Database.Transaction, NSError> {
    let predicate = NSPredicate(format: "id == %@", id as CVarArg)
    return fetchPublisher(with: predicate).compactMap { $0.first }
      .eraseToAnyPublisher()
  }

  public func fetchPublisher(from start: Date, closedTo end: Date = Date()) -> AnyPublisher<[Database.Transaction], NSError> {
    let predicate = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)
    return fetchPublisher(with: predicate)
  }

  public func fetchPublisher(from start: Date, to end: Date = Date()) -> AnyPublisher<[Database.Transaction], NSError> {
    let predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
    return fetchPublisher(with: predicate)
  }
}

