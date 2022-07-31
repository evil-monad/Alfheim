//
//  Persistences+Account.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/8.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData
import Database

extension Persistences {
  struct Account {
    let context: NSManagedObjectContext
    let publisher: Publisher

    typealias FetchRequestPublisher = Publishers.FetchRequest<Database.Account>

    init(context: NSManagedObjectContext) {
      self.context = context
      self.publisher = Publisher(context: context)
    }

    enum Buildin: String {
      case expenses

      var name: String {
        return rawValue.capitalized
      }

      var id: String {
        switch self {
        case .expenses:
          return "_expenses"
        }
      }
    }

    // MARK: - Operators, CURD

    func count(with predicate: NSPredicate? = nil) throws -> Int {
      let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
      fetchRequest.predicate = predicate
      return try context.count(for: fetchRequest)
    }

    func empty() throws -> Bool {
      return try count() == 0
    }

    /// Needs executed within a context  in scope
    func all() throws -> [Database.Account] {
      let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
      return try fetchRequest.execute()
    }

    /// Without a context in scope
    func empty(block: @escaping (Result<Bool, Error>) -> Void) {
      context.perform {
        do {
          block(.success(try self.all().isEmpty))
        } catch {
          block(.failure(error))
        }
      }
    }

    /// Delete, without save.
    func delete(_ object: NSManagedObject) {
      context.delete(object)
    }

    /// Fetch with predicate, should use in context queue
    func fetch(with predicate: NSPredicate) throws -> [Database.Account] {
      let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
      fetchRequest.predicate = predicate
      return try context.fetch(fetchRequest)
    }

    /// Save if has changes, should use in context.perform(_:) block if you need to update results, if not, update notification won't be send to
    /// subscriber, NSFetchedResultsController for example.
    func save() throws {
      guard context.hasChanges else {
        return
      }
      try context.save()
    }

    func account(withID id: UUID) -> Database.Account? {
      let predicate = NSPredicate(format: "id == %@", id as CVarArg)
      guard let object = context.registeredObjects(Database.Account.self, with: predicate).first else {
        return nil
      }
      return object
    }

    // MARK: - Async
    func fetchAll() async throws -> [Database.Account] {
      try await performFetch(request: Database.Account.fetchRequest())
    }

    func fetch(withID id: UUID) async throws -> Database.Account? {
      let request: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
      return try await performFetch(request: request).first
    }

    private func performFetch(request: NSFetchRequest<Database.Account>) async throws -> [Database.Account] {
      try await context.perform {
        return try context.fetch(request)
      }
    }

    // MARK: - Publishes

    struct Publisher {
      let context: NSManagedObjectContext

      func fetchRequest(sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "name", ascending: true)],
                        predicate: NSPredicate? = nil) -> FetchRequestPublisher {
        let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return Publishers.FetchRequest(fetchRequest: fetchRequest, context: context)
      }

      func fetchAll() -> AnyPublisher<[Database.Account], NSError> {
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return fetchRequest(sortDescriptors: sortDescriptors).eraseToAnyPublisher()
      }

      func fetch(with predicate: NSPredicate) -> AnyPublisher<[Database.Account], NSError> {
        fetchRequest(predicate: predicate)
          .eraseToAnyPublisher()
      }

      func fetch(withName name: String) -> AnyPublisher<Database.Account, NSError> {
        let predicate = NSPredicate(format: "name == %@", name)
        return fetch(with: predicate).compactMap { $0.first }
          .eraseToAnyPublisher()
      }

      func fetch(withID id: UUID) -> AnyPublisher<Database.Account, NSError> {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return fetch(with: predicate).compactMap { $0.first }
          .eraseToAnyPublisher()
      }
    }
  }
}
