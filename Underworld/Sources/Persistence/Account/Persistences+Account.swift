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

public struct Account {
  public let context: NSManagedObjectContext
  public let publisher: Publisher

  public typealias FetchRequestPublisher = Publishers.FetchRequest<Database.Account>

  public init(context: NSManagedObjectContext) {
    self.context = context
    self.publisher = Publisher(context: context)
  }

  public enum Buildin: String {
    case expenses

    public var name: String {
      return rawValue.capitalized
    }

    public var id: String {
      switch self {
      case .expenses:
        return "_expenses"
      }
    }
  }

  // MARK: - Operators, CURD

  public func count(with predicate: NSPredicate? = nil) throws -> Int {
    let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
    fetchRequest.predicate = predicate
    return try context.count(for: fetchRequest)
  }

  public func empty() throws -> Bool {
    return try count() == 0
  }

  /// Needs executed within a context  in scope
  public func all() throws -> [Database.Account] {
    let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
    return try fetchRequest.execute()
  }

  /// Without a context in scope
  public func empty(block: @escaping (Result<Bool, Error>) -> Void) {
    context.perform {
      do {
        block(.success(try self.all().isEmpty))
      } catch {
        block(.failure(error))
      }
    }
  }

  /// Delete, without save.
  public func delete(_ object: NSManagedObject) {
    context.delete(object)
  }

  /// Fetch with predicate, should use in context queue
  public func fetch(with predicate: NSPredicate) throws -> [Database.Account] {
    let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
    fetchRequest.predicate = predicate
    return try context.fetch(fetchRequest)
  }

  /// Save if has changes, should use in context.perform(_:) block if you need to update results, if not, update notification won't be send to
  /// subscriber, NSFetchedResultsController for example.
  public func save() throws {
    guard context.hasChanges else {
      return
    }
    try context.save()
  }

  public func account(withID id: UUID) -> Database.Account? {
    let predicate = NSPredicate(format: "id == %@", id as CVarArg)
    guard let object = context.registeredObjects(Database.Account.self, with: predicate).first else {
      return nil
    }
    return object
  }

  // MARK: - Async
  public func fetchAll() async throws -> [Database.Account] {
    try await performFetch(request: Database.Account.fetchRequest())
  }

  public func fetch(withID id: UUID) async throws -> Database.Account? {
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

  public struct Publisher {
    public let context: NSManagedObjectContext

    public func fetchRequest(sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "name", ascending: true)],
                      predicate: NSPredicate? = nil) -> FetchRequestPublisher {
      let fetchRequest: NSFetchRequest<Database.Account> = Database.Account.fetchRequest()
      fetchRequest.sortDescriptors = sortDescriptors
      fetchRequest.predicate = predicate
      return Publishers.FetchRequest(fetchRequest: fetchRequest, context: context)
    }

    public func fetchAll() -> AnyPublisher<[Database.Account], NSError> {
      let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
      return fetchRequest(sortDescriptors: sortDescriptors).eraseToAnyPublisher()
    }

    public func fetch(with predicate: NSPredicate) -> AnyPublisher<[Database.Account], NSError> {
      fetchRequest(predicate: predicate)
        .eraseToAnyPublisher()
    }

    public func fetch(withName name: String) -> AnyPublisher<Database.Account, NSError> {
      let predicate = NSPredicate(format: "name == %@", name)
      return fetch(with: predicate).compactMap { $0.first }
        .eraseToAnyPublisher()
    }

    public func fetch(withID id: UUID) -> AnyPublisher<Database.Account, NSError> {
      let predicate = NSPredicate(format: "id == %@", id as CVarArg)
      return fetch(with: predicate).compactMap { $0.first }
        .eraseToAnyPublisher()
    }
  }
}
