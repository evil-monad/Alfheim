//
//  Persistences+Cloud.swift
//  Persistences+Cloud
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData
import Domain

public final class CloudPersistent: Persistent {
  let store: CloudStore
  public var context: NSManagedObjectContext {
    store.container.viewContext
  }

  public init() {
    store = CloudStore()
    store.reloadContainer()
  }

  public func save() {
    store.saveContext()
  }

  public func reload() {
    store.reloadContainer()
  }

  public func observe<T>(_ request: FetchedRequest<T>, transform: @Sendable @escaping ([T.ResultType]) -> [T]) -> AsyncStream<[T]> where T : FetchedResult {
    let fetchRequest = request.makeFetchRequest()
    let observer = FetchRequestObserver(fetchRequest: fetchRequest, context: context)
    return AsyncStream<[T]> { continuation in
      Task.detached {
        let observe = await observer.observe().map(transform)
        observer.fetch()
        for await result in observe {
          continuation.yield(result)
        }
        continuation.finish()
      }
    }
  }

  public func asyncObserve<T>(_ request: FetchedRequest<T>) async -> AsyncStream<[T]> where T : FetchedResult {
    let fetchRequest = request.makeFetchRequest()
    let observer = FetchRequestObserver(fetchRequest: fetchRequest, context: context)
    let observe = await observer.observe().map { T.map($0) }
    observer.fetch()
    return observe.eraseToStream()
  }

//  func observeUpdated<T>(_ request: FetchedRequest<T>) -> AsyncStream<[T]> {
//    .init { continuation in
//      Task.detached { [unowned self] in
//        let values = try? await self.fetch(request)
//        continuation.yield(values ?? [])
//
//        for await notification in NotificationCenter.default.notifications(named: NSManagedObjectContext.didSaveObjectsNotification) {
//          guard let objects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
//
//          objects.forEach { object in
//            object.changedValues()
//          }
//        }
//      }
//    }
//  }

  public func fetch<T>(_ request: FetchedRequest<T>) async throws -> [T] where T : FetchedResult {
    try await store.schedule { context in
      try context.fetch(request).compactMap { T.init(from: $0) }
    }
  }

  public func fetch<T>(_ request: FetchedRequest<T>, transform: @escaping ([T.ResultType]) -> [T]) async throws -> [T] {
    try await store.schedule { context in
      transform(try context.fetch(request))
    }
  }

  public func update<T: FetchedResult>(_ item: T) async throws -> Bool {
    try await store.schedule { context in
      let predicate = NSPredicate(format: "id == %@", item.id as! CVarArg)
      if let object = try context.fetchOne(T.all.filter(predicate)) {
        try object.update(item)
        return true
      } else {
        return false
      }
    }
  }

  public func update<T: FetchedResult, V>(_ item: T, keyPath: WritableKeyPath<T.ResultType, V>, value: V) async throws -> Bool {
    try await store.schedule { context in
      guard var object = try context.fetchOne(T.all.where(T.identifier == item.id)) else {
        return false
      }
      object[keyPath: keyPath] = value
      return true
    }
  }

  public func update<T: FetchedResult, V>(_ id: T.ID, keyPath: WritableKeyPath<T.ResultType, V>, value: V) async throws -> T {
    try await store.schedule { context in
      guard var object = try context.fetchOne(T.all.where(T.identifier == id)) else {
        throw FetchedError.notFound
      }

      object[keyPath: keyPath] = value

      if let item = T.decode(from: object) {
        return item
      }
      throw FetchedError.decode(String(describing: id))
    }
  }

  public func update<T: FetchedResult, R: FetchedResult>(_ item: T, relationships: [(keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, value: R?)]) async throws -> Bool {
    try await store.schedule { context in
      guard var object = try context.fetchOne(T.all.where(T.identifier == item[keyPath: T.identifier])) else {
        return false
      }

      try object.update(item)

      for relationship in relationships {
        if let value = relationship.value, let toValue = try context.fetchOne(R.all.where(R.identifier == value[keyPath: R.identifier])) {
          object[keyPath: relationship.keyPath] = toValue
        } else {
          object[keyPath: relationship.keyPath] = nil
        }
      }

      return true
    }
  }

  public func insert<T: FetchedResult>(_ item: T) async throws {
    try await store.schedule { context in
      let _ = item.encode(to: context)
    }
  }

  public func insert<T: FetchedResult, R: FetchedResult>(_ item: T, relationships: [(keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, value: R?)]) async throws {
    try await store.schedule { context in
      var result = item.encode(to: context)
      for relationship in relationships {
        if let value = relationship.value, let toValue = try context.fetchOne(R.all.where(R.identifier == value[keyPath: R.identifier])) {
          result[keyPath: relationship.keyPath] = toValue
        } else {
          result[keyPath: relationship.keyPath] = nil
        }
      }
    }
  }

  public func delete<T: FetchedResult>(_ item: T) async throws {
    try await store.schedule { context in
      try context.delete(T.all.where(T.identifier == item[keyPath: T.identifier]))
    }
  }

  public func sync<T: FetchedResult, R: FetchedResult>(item: T, keyPath: WritableKeyPath<T.ResultType, R.ResultType>, to relation: R) async throws -> Bool {
    try await store.schedule { context in
      if var result = try context.fetchOne(T.all.filter(NSPredicate(format: "id == %@", item.id as! CVarArg))),
         let value = try context.fetchOne(R.all.filter(NSPredicate(format: "id == %@", relation.id as! CVarArg))) {
        result[keyPath: keyPath] = value
        return true
      } else {
        return false
      }
    }
  }

  public func sync<T: FetchedResult, R: FetchedResult>(item: T, keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, to relation: R?) async throws -> Bool {
    try await store.schedule { context in
      if var result = try context.fetchOne(T.all.where(T.identifier == item.id)) {
        if let relation = relation, let value = try context.fetchOne(R.all.filter(R.identifier == relation.id)) {
          result[keyPath: keyPath] = value
        } else {
          result[keyPath: keyPath] = nil
        }
        return true
      } else {
        return false
      }
    }
  }
}
