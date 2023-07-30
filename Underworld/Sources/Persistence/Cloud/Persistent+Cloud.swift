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

  public func fetch<T>(_ request: Request<T>) async throws -> [T] where T : FetchedResult {
    let fetchRequest = request.makeFetchRequest()
    let fetchedRequest = FetchedRequest(fetchRequest: fetchRequest, context: context)
    let results = fetchedRequest.fetchedResults.compactMap { T.init(from: $0) }
    return results
  }

  public func observe<T>(_ request: Request<T>) -> AsyncStream<[T]> where T : FetchedResult {
    let fetchRequest = request.makeFetchRequest()
    let fetchedRequest = FetchedRequest(fetchRequest: fetchRequest, context: context)
    return AsyncStream<[T]> { continuation in
      Task.detached {
        let observe = await fetchedRequest.observe().map { T.map($0) }
        fetchedRequest.fetch()
        for await result in observe {
          continuation.yield(result)
        }
        continuation.finish()
      }
    }
  }

  public func asyncObserve<T>(_ request: Request<T>) async -> AsyncStream<[T]> where T : FetchedResult {
    let fetchRequest = request.makeFetchRequest()
    let fetchedRequest = FetchedRequest(fetchRequest: fetchRequest, context: context)
    let observe = await fetchedRequest.observe().map { T.map($0) }
    fetchedRequest.fetch()
    return observe.eraseToStream()
  }

  public func insert<T: FetchedResult>(_ item: T) async throws {
    let context = store.newBackgroundContext()
    let object = item.encode(to: context)
    try await context.perform(schedule: .immediate) {
      try context.save()
    }
  }
}
