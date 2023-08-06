//
//  FetchRequestObserver.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class FetchRequestObserver<Result> where Result: NSFetchRequestResult {
  private var controller: NSFetchedResultsController<Result>
  private let delegate: Delegate<Result>
  private let observer: Observer<Result>

  var fetchedResults: [Result] {
    delegate.controller.fetchedObjects ?? []
  }
  
  public init(fetchRequest: NSFetchRequest<Result>, context: NSManagedObjectContext) {
    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil)

    self.controller = controller
    self.delegate = Delegate(controller: controller)
    self.observer = Observer(controller: controller)
  }

  func observe(relationships: [Relationship] = []) async -> AsyncStream<[Result]> {
    observer.observe(relationships: relationships)
    return AsyncStream<[Result]> { continuation in
      self.delegate.continuation = continuation
    }
  }

  func fetch() {
    delegate.fetch()
  }

  func cancel() {
    delegate.cancel()
    observer.cancel()
  }
}

final private class Observer<Result>: NSObject where Result: NSFetchRequestResult {
  unowned let controller: NSFetchedResultsController<Result>
  var relationships: [Relationship] = []

  var updatedObjects: Set<NSManagedObjectID> = []

  init(controller: NSFetchedResultsController<Result>) {
    self.controller = controller
    super.init()
  }

  func observe(relationships: [Relationship] = []) {
    guard !relationships.isEmpty else {
      return
    }
    self.relationships = relationships
    NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange(_:)), name: NSManagedObjectContext.didChangeObjectsNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: NSManagedObjectContext.didSaveObjectsNotification, object: nil)
  }

  func cancel() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc
  private func contextDidChange(_ notification: NSNotification) {
    guard let fetchedObjects = controller.fetchedObjects as? [NSManagedObject] else { return }
    guard let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }

    for fetched in fetchedObjects {
      var observedObjects: Set<NSManagedObjectID> = []
      for relationship in relationships {
        //let value = fetched[keyPath: relationship.keyPath]
        let value = fetched.value(forKeyPath: relationship.name)
        if let toManyObjects = value as? Set<NSManagedObject> {
          toManyObjects.forEach {
            observedObjects.insert($0.objectID)
          }
        } else if let toOneObject = value as? NSManagedObject {
          observedObjects.insert(toOneObject.objectID)
        } else {
          assertionFailure("Invalid relationship observed for keyPath: \(relationship.keyPath)")
          return
        }
      }
      if !observedObjects.intersection(updatedObjects.map(\.objectID)).isEmpty {
        self.updatedObjects.insert(fetched.objectID)
      }
    }
  }

  @objc
  private func contextDidSave(_ notification: NSNotification) {
    guard !updatedObjects.isEmpty else { return }
    guard let fetchedObjects = controller.fetchedObjects as? [NSManagedObject], !fetchedObjects.isEmpty else { return }

    fetchedObjects.forEach { object in
        guard updatedObjects.contains(object.objectID) else { return }
        controller.managedObjectContext.refresh(object, mergeChanges: true)
    }
    updatedObjects.removeAll()
  }
}

/// `NSFetchedResultsController` is only designed to watch one entity at a time.
/// https://www.avanderlee.com/swift/nsfetchedresultscontroller-observe-relationship-changes/
final private class Delegate<Result>: NSObject, NSFetchedResultsControllerDelegate where Result: NSFetchRequestResult {
  var continuation: AsyncStream<[Result]>.Continuation?
  unowned let controller: NSFetchedResultsController<Result>

  init(controller: NSFetchedResultsController<Result>) {
    self.controller = controller
    super.init()
  }

  deinit {
    continuation?.finish()
  }

  func fetch() {
    guard let continuation = continuation else {
      return
    }

    controller.delegate = self

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
  }

  public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let continuation = continuation, let objects = self.controller.fetchedObjects else {
      return
    }

    continuation.yield(objects)
  }
}
