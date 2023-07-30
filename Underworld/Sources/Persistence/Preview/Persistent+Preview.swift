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
  public func fetch<T>(_ request: Request<T>) async throws -> [T] where T : FetchedResult {
    return []
  }

  public func observe<T>(_ request: Request<T>) -> AsyncStream<[T]> where T : FetchedResult {
    return .init {
      $0.yield([])
      $0.finish()
    }
  }

  public func asyncObserve<T>(_ request: Request<T>) async -> AsyncStream<[T]> where T : FetchedResult {
    observe(request)
  }

  public func insert<T>(_ item: T) async throws where T : FetchedResult {
    let object = item.encode(to: context)
    try await context.perform(schedule: .immediate) { [unowned self] in
      try self.context.save()
    }
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
