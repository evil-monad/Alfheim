//
//  Publishers+CoreData.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/8.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData

extension Publishers {
  struct FetchedResults<Result>: Publisher where Result: NSFetchRequestResult {
    typealias Output = [Result]
    typealias Failure = NSError

    let fetchRequest: NSFetchRequest<Result>
    let context: NSManagedObjectContext

    init(fetchRequest: NSFetchRequest<Result>, context: NSManagedObjectContext) {
      self.fetchRequest = fetchRequest
      self.context = context
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
      let subscription = FetchedResultsSubscription(subscriber: subscriber, fetchRequest: fetchRequest, context: context)
      subscriber.receive(subscription: subscription)
    }
  }

  final class FetchedResultsSubscription<Subscriber, Result>
    : NSObject, Subscription, NSFetchedResultsControllerDelegate
    where Subscriber: Combine.Subscriber,
    Subscriber.Input == [Result],
    Subscriber.Failure == NSError,
    Result: NSFetchRequestResult {

    private var subscriber: Subscriber?
    private var context: NSManagedObjectContext?
    private var fetchRequest: NSFetchRequest<Result>?
    private var controller: NSFetchedResultsController<Result>?

    init(subscriber: Subscriber, fetchRequest: NSFetchRequest<Result>, context: NSManagedObjectContext) {
      self.subscriber = subscriber
      self.fetchRequest = fetchRequest
      self.context = context
    }

    func request(_ demand: Subscribers.Demand) {
      guard demand > 0, let subscriber = subscriber, let fetchRequest = fetchRequest, let context = context else {
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
        subscriber.receive(completion: .failure(error as NSError))
      }
    }

    func cancel() {
      subscriber = nil
      controller = nil
      fetchRequest = nil
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
