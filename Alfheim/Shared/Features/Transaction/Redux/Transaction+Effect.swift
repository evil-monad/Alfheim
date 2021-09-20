//
//  AppEffect+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture
import CoreData

extension AppEffects {
  enum Transaction {
    static func create(snapshot: Alfheim.Transaction.Snapshot, context: NSManagedObjectContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistences.Transaction(context: context)
      let object = Alfheim.Transaction(context: context)
      object.fill(snapshot)

      return Future { promise in
        do {
          try persistence.save()
          promise(.success(true))
        } catch {
          print("Create transaction failed: \(error)")
          promise(.failure(error as NSError))
        }
      }
      .eraseToEffect()
    }

    static func update(snapshot: Alfheim.Transaction.Snapshot, context: NSManagedObjectContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistences.Transaction(context: context)
      if let object = persistence.transaction(withID: snapshot.id) {
        object.fill(snapshot)
      } else {
        fatalError("Should not be here!")
      }

      return Future { promise in
        do {
          try persistence.save()
          promise(.success(true))
        } catch {
          print("Update transaction failed: \(error)")
          promise(.failure(error as NSError))
        }
      }
      .eraseToEffect()
    }

    static func updateFlag(_ flag: Bool, with id: UUID, context: NSManagedObjectContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistences.Transaction(context: context)
      if let object = persistence.transaction(withID: id) {
        object.flagged = flag
      } else {
        fatalError("Should not be here!")
      }

      return Future { promise in
        do {
          try persistence.save()
          promise(.success(true))
        } catch {
          print("Update transaction failed: \(error)")
          promise(.failure(error as NSError))
        }
      }
      .eraseToEffect()
    }

    static func delete(with ids: [UUID], in context: NSManagedObjectContext?) -> Effect<Bool, NSError> {
      guard let context = context, !ids.isEmpty else {
        return Effect.none
      }

      let persistence = Persistences.Transaction(context: context)
      let transactions = ids.compactMap { persistence.transaction(withID: $0) }

      return delete(transactions: transactions, in: context)
    }

    static func delete(transactions: [Alfheim.Transaction], in context: NSManagedObjectContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      guard !transactions.isEmpty else {
        return .none
      }

      let persistence = Persistences.Transaction(context: context)

      for transaction in transactions {
        if let object = persistence.transaction(withID: transaction.id) {
          persistence.delete(object)
        } else {
          assert(false, "shouldn't be here")
        }
      }

      return Future { promise in
        do {
          try persistence.save()
          promise(.success(true))
        } catch {
          print("Delete transaction failed: \(error)")
          promise(.failure(error as NSError))
        }
      }
      .eraseToEffect()
    }

    static func save(in context: NSManagedObjectContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistences.Transaction(context: context)
      return Future { promise in
        do {
          try persistence.save()
          promise(.success(true))
        } catch {
          print("save transaction failed: \(error)")
          promise(.failure(error as NSError))
        }
      }
      .eraseToEffect()
    }

    static func fetch(environment: AppEnvironment) -> Effect<AppAction, Never> {
      guard let context = environment.context else {
        return Effect.none
      }

      return Persistences.Transaction(context: context)
        .fetchAllPublisher()
        .replaceError(with: [])
        .map { transactions in
          .transactionDidChange(transactions)
        }
        .eraseToEffect()
    }
  }
}
