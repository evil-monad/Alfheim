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
import Persistence
import Database
import Domain

extension Transaction {
  enum Effects {
    static func create(model: Domain.Transaction, context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistence.Transaction(context: context)
      let entity = Database.Transaction(context: context)
      entity.fill(model)

      let controller = Persistence.Account(context: context)
      if let target = controller.account(withID: model.target.id) {
        entity.fill(target: target)
      }
      if let source = controller.account(withID: model.source.id) {
        entity.fill(source: source)
      }

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

    static func update(model: Domain.Transaction, context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistence.Transaction(context: context)
      if let entity = persistence.transaction(withID: model.id) {
        entity.fill(model)

        let controller = Persistence.Account(context: context)
        if let target = controller.account(withID: model.target.id) {
          entity.fill(target: target)
        }
        if let source = controller.account(withID: model.source.id) {
          entity.fill(source: source)
        }
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

    static func updateFlag(_ flag: Bool, with id: UUID, context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistence.Transaction(context: context)
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

    static func delete(with ids: [UUID], in context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context, !ids.isEmpty else {
        return Effect.none
      }

      let persistence = Persistence.Transaction(context: context)
      let transactions = ids.compactMap { persistence.transaction(withID: $0) }

      return delete(transactions: transactions, in: context)
    }

    static func delete(transactions: [Database.Transaction], in context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      guard !transactions.isEmpty else {
        return .none
      }

      let persistence = Persistence.Transaction(context: context)

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

    static func save(in context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistence.Transaction(context: context)
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

    static func fetch(context: AppContext?) -> Effect<App.Action, Never> {
      guard let context = context else {
        return Effect.none
      }

      return Persistence.Transaction(context: context)
        .fetchAllPublisher()
        .replaceError(with: [])
        .map { transactions in
          App.Action.fetchAccounts // refresh accounts
          //App.Action.transactionDidChange(transactions.compactMap(Domain.Transaction.init))
        }
        .eraseToEffect()
    }
  }
}