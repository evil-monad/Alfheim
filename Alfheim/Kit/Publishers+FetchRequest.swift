//
//  Publishers+FetchRequest.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData

extension Publishers {
  struct FetchRequest<Result>: Publisher where Result: NSFetchRequestResult {
    typealias Output = [Result]
    typealias Failure = NSError

    private let fetchRequest: NSFetchRequest<Result>
    private let context: NSManagedObjectContext

    init(fetchRequest: NSFetchRequest<Result>, context: NSManagedObjectContext) {
      self.fetchRequest = fetchRequest
      self.context = context
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
      let subscription = FetchRequestSubscription(subscriber: subscriber, request: fetchRequest, context: context)
      subscriber.receive(subscription: subscription)
    }
  }

  final private class FetchRequestSubscription<Subscriber, Result>
    : NSObject, Subscription, NSFetchedResultsControllerDelegate
    where Subscriber: Combine.Subscriber,
    Subscriber.Input == [Result],
    Subscriber.Failure == NSError,
    Result: NSFetchRequestResult {

    private var subscriber: Subscriber?
    private var context: NSManagedObjectContext?
    private var request: NSFetchRequest<Result>?
    private var controller: NSFetchedResultsController<Result>?

    init(subscriber: Subscriber, request: NSFetchRequest<Result>, context: NSManagedObjectContext) {
      self.subscriber = subscriber
      self.request = request
      self.context = context
    }

    func request(_ demand: Subscribers.Demand) {
      guard demand > 0, let subscriber = subscriber, let fetchRequest = request, let context = context else {
        return
      }

      let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                  managedObjectContext: context,
                                                  sectionNameKeyPath: nil,
                                                  cacheName: nil)

      controller.delegate = self
      self.controller = controller

      do {
        try controller.performFetch()
        if let objects = controller.fetchedObjects {
            _ = subscriber.receive(objects)
        }
      } catch {
        // Should map to value?
        subscriber.receive(completion: .failure(error as NSError))
      }
    }

    func cancel() {
      subscriber = nil
      controller = nil
      request = nil
      context = nil
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      guard let subscriber = subscriber, self.controller == controller else {
        return
      }

      guard let objects = self.controller?.fetchedObjects else {
        return
      }
      _ = subscriber.receive(objects)
    }
  }
}

