//
//  FetchedRequest.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class FetchedRequest<Result> where Result: NSFetchRequestResult {
  private let delegate: Delegate<Result>

  var fetchedResults: [Result] {
    delegate.controller?.fetchedObjects ?? []
  }
  
  public init(fetchRequest: NSFetchRequest<Result>, context: NSManagedObjectContext) {
    self.delegate = Delegate(request: fetchRequest, context: context)
  }

  func observe() async -> AsyncStream<[Result]> {
    AsyncStream<[Result]> { continuation in
      self.delegate.continuation = continuation
    }
  }

  func fetch() {
    delegate.fetch()
  }

  func cancel() {
    delegate.cancel()
  }
}

final private class Delegate<Result>: NSObject, NSFetchedResultsControllerDelegate where Result: NSFetchRequestResult {
  var continuation: AsyncStream<[Result]>.Continuation?
  private var context: NSManagedObjectContext
  private var request: NSFetchRequest<Result>
  var controller: NSFetchedResultsController<Result>?

  init(request: NSFetchRequest<Result>, context: NSManagedObjectContext) {
    self.request = request
    self.context = context
  }

  deinit {
    continuation?.finish()
  }

  func fetch() {
    guard let continuation = continuation else {
      return
    }

    let controller = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil)

    controller.delegate = self
    self.controller = controller

    do {
      try controller.performFetch()
      if let objects = controller.fetchedObjects {
        continuation.yield(objects)
      }
    } catch {
      // Should map to value?
      // TODO: throw error
      print(error)
    }
  }

  func cancel() {
    continuation?.finish()
    controller = nil
  }

  public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard self.controller == controller else {
      return
    }

    guard let continuation = continuation, let objects = self.controller?.fetchedObjects else {
      return
    }

    continuation.yield(objects)
  }
}
