//
//  CoreData+Request.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/30.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import CoreData

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

public protocol Predicate<Root>: NSPredicate {
    associatedtype Root: FetchedResult
}

public final class ComparisonPredicate<Root: FetchedResult>: NSComparisonPredicate, Predicate {}

extension ComparisonPredicate {
  convenience init(
    _ keyPath: KeyPath<Root, Root.ID>,
    _ op: NSComparisonPredicate.Operator,
    _ id: Root.ID
  ) {
    let lhs = NSExpression(forKeyPath: "id") // NSExpression(forKeyPath: keyPath)
    let rhs = NSExpression(forConstantValue: id)
    self.init(leftExpression: lhs, rightExpression: rhs, modifier: .direct, type: op)
  }
}

public func == <Root> (keyPath: KeyPath<Root, Root.ID>, id: Root.ID) -> ComparisonPredicate<Root> {
  ComparisonPredicate(keyPath, .equalTo, id)
}
