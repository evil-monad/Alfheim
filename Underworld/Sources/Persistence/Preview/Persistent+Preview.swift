//
//  Persistences+Preview.swift
//  Alfheim
//
//  Created by alex.huo on 2021/7/24.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class PreviewPersistent: Persistent {
  public func update<T: FetchedResult, V>(_ id: T.ID, keyPath: WritableKeyPath<T.ResultType, V>, value: V) async throws -> T {
    let object = try context.fetchOne(T.all.where(T.identifier == id))
    return T.decode(from: object!)!
  }

  public func update<T: FetchedResult, V>(_ item: T, keyPath: WritableKeyPath<T.ResultType, V>, value: V) async throws -> Bool {
    return true
  }

  public func update<T, R>(_ item: T, relationships: [(keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, value: R?)]) async throws -> Bool where T : FetchedResult, R : FetchedResult {
    return false
  }

  public func observe<T>(_ request: FetchedRequest<T>, transform: @Sendable @escaping ([T.ResultType]) -> [T]) -> AsyncStream<[T]> where T : FetchedResult {
    return .init {
      $0.yield([])
      $0.finish()
    }
  }

  public func asyncObserve<T>(_ request: FetchedRequest<T>) async -> AsyncStream<[T]> where T : FetchedResult {
    observe(request)
  }

  public func fetch<T>(_ request: FetchedRequest<T>) async throws -> [T] where T : FetchedResult {
    try context.fetch(request).compactMap { T.init(from: $0) }
  }

  public func fetch<T>(_ request: FetchedRequest<T>, transform: @escaping ([T.ResultType]) -> [T]) async throws -> [T] {
    T.map(try context.fetch(request))
  }

  public func update<T>(_ item: T) async throws -> Bool where T : FetchedResult {
    let predicate = NSPredicate(format: "id == %@", item.id as! CVarArg)
    if let object = context.registeredObjects(T.ResultType.self, with: predicate).first {
      try object.update(item)
      return true
    }
    return false
  }

  public func insert<T>(_ item: T) async throws where T : FetchedResult {
    let _ = item.encode(to: context)
    try await context.perform(schedule: .immediate) { [unowned self] in
      try self.context.save()
    }
  }

  public func insert<T: FetchedResult, R: FetchedResult>(_ item: T, relationships: [(keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, value: R?)]) async throws {
  }

  public func delete<T: FetchedResult>(_ item: T) async throws {
    try context.delete(T.all.where(T.identifier == item[keyPath: T.identifier]))
  }

  public func sync<T, R>(item: T, keyPath: WritableKeyPath<T.ResultType, R.ResultType>, to relation: R) async throws -> Bool where T : FetchedResult, R : FetchedResult {
    return false
  }

  public func sync<T, R>(item: T, keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, to relation: R?) async throws -> Bool where T : FetchedResult, R : FetchedResult {
    return false
  }

  let store: MemoryStore
  public let context: NSManagedObjectContext

  public init() {
    store = MemoryStore()
    context = store.persistentContainer.viewContext

    // preview memory data
  }

  public func save() {
    store.saveContext()
  }

  public func reload() {

  }
}
