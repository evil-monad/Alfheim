//
//  CoreData+Request.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/30.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import CoreData
import Domain

public extension NSManagedObjectContext {
  func fetch<T>(_ request: FetchedRequest<T>) throws -> [T.ResultType] {
    let fetchRequest = request.makeFetchRequest()
    return try self.fetch(fetchRequest)
  }

  func fetchOne<T>(_ request: FetchedRequest<T>) throws -> T.ResultType? {
    try self.fetch(request.limit(1)).first
  }

  func delete<T>( _ request: FetchedRequest<T>) throws {
    let items = try self.fetch(request)

    for item in items where item is NSManagedObject {
      self.delete(item as! NSManagedObject) // .managedObjectResultType
    }
  }
}

public extension NSManagedObjectContext {
  func registeredObjects(with predicate: NSPredicate) -> Set<NSManagedObject> {
    registeredObjects.filter { predicate.evaluate(with: $0) }
  }

  func registeredObjects<T>(_ type: T.Type, with predicate: NSPredicate) -> [T] {
    (registeredObjects.compactMap { $0 as? T }).filter { predicate.evaluate(with: $0) }
  }
}

public extension NSManagedObjectContext {
  func execute<T>(_ action: @Sendable @escaping (NSManagedObjectContext) throws -> T) throws -> T {
    defer {
      self.reset()
    }

    let value = try action(self)
    if hasChanges {
      try save()
    }
    return value
  }
}
