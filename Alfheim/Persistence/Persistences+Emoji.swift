//
//  Persistences+Emoji.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData

//extension Persistences {
//  struct Emoji {
//    let context: NSManagedObjectContext
//
//    typealias FetchRequestPublisher = Publishers.FetchRequest<Alfheim.Emoji>
//
//    // MARK: - Operators, CURD
//
//    /// Fetch with predicate, should use in context queue
//    func fetch(with predicate: NSPredicate) throws -> [Alfheim.Emoji] {
//      let fetchRequest: NSFetchRequest<Alfheim.Emoji> = Alfheim.Emoji.fetchRequest()
//      fetchRequest.predicate = predicate
//      return try context.fetch(fetchRequest)
//    }
//
//    /// Save if has changes, should use in context.perform(_:) block if you need to update results, if not, update notification won't be send to
//    /// subscriber, NSFetchedResultsController for example.
//    func save() throws {
//      guard context.hasChanges else {
//        return
//      }
//      try context.save()
//    }
//
//    /// Delete, without save.
//    func delete(_ object: NSManagedObject) {
//      context.delete(object)
//    }
//
//    func emojis(inCategory category: String) -> [Alfheim.Emoji] {
//      let predicate = NSPredicate(format: "category == %@", category)
//      let objects = context.registeredObjects(Alfheim.Emoji.self, with: predicate)
//      return objects
//    }
//
//    func emojis(in category: Category) -> [Alfheim.Emoji] {
//      return emojis(inCategory: category.name)
//    }
//
//    func emoji(withText text: String) -> Alfheim.Emoji? {
//      let predicate = NSPredicate(format: "text == %@", text)
//      let emojis = context.registeredObjects(Alfheim.Emoji.self, with: predicate)
//      return emojis.first
//    }
//
//    func fetch(withCategory category: String, text: String) throws -> [Alfheim.Emoji] {
//      let predicate = NSPredicate(format: "(category == %@) AND (text == %@)", category, text)
//      let fetchRequest: NSFetchRequest<Alfheim.Emoji> = Alfheim.Emoji.fetchRequest()
//      fetchRequest.predicate = predicate
//      return try context.fetch(fetchRequest)
//    }
//
//    func exists(withText text: String) -> Bool {
//      let predicate = NSPredicate(format: "text == %@", text)
//      let emojis = context.registeredObjects(Alfheim.Emoji.self, with: predicate)
//      return !emojis.isEmpty
//    }
//
//    // MARK: - Publishes
//
//    func fetchRequestPublisher(sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "text", ascending: true)],
//                               predicate: NSPredicate? = nil) -> FetchRequestPublisher {
//      let fetchRequest: NSFetchRequest<Alfheim.Emoji> = Alfheim.Emoji.fetchRequest()
//      fetchRequest.sortDescriptors = sortDescriptors
//      fetchRequest.predicate = predicate
//      return Publishers.FetchRequest(fetchRequest: fetchRequest, context: context)
//    }
//
//    func fetchAllPublisher() -> AnyPublisher<[Alfheim.Emoji], NSError> {
//      let sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
//      return fetchRequestPublisher(sortDescriptors: sortDescriptors).eraseToAnyPublisher()
//    }
//
//    func fetchPublisher(with predicate: NSPredicate) -> AnyPublisher<[Alfheim.Emoji], NSError> {
//      fetchRequestPublisher(predicate: predicate)
//        .eraseToAnyPublisher()
//    }
//
//    func fetchPublisher(inCategory category: String) -> AnyPublisher<[Alfheim.Emoji], NSError> {
//      let predicate = NSPredicate(format: "category == %@", category)
//      return fetchPublisher(with: predicate)
//        .eraseToAnyPublisher()
//    }
//
//    func fetchPublisher(in category: Category) -> AnyPublisher<[Alfheim.Emoji], NSError> {
//      fetchPublisher(inCategory: category.name)
//    }
//
//    func fetchPublisher(withText text: String) -> AnyPublisher<Alfheim.Emoji, NSError> {
//      let predicate = NSPredicate(format: "text == %@", text)
//      return fetchPublisher(with: predicate).compactMap { $0.first }
//        .eraseToAnyPublisher()
//    }
//  }
//}
