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
      // TBD:
      // Effect.fireAndForget { }
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

    static func update(transaction: Alfheim.Transaction.Snapshot, context: NSManagedObjectContext?) -> Effect<Bool, NSError> {
      // TBD:
      // Effect.fireAndForget { }
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistences.Transaction(context: context)
      if let object = persistence.transaction(withID: transaction.id) {
        object.fill(transaction)
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
  }
}

//extension AppCommands {
//  struct LoadTransactionsCommand: AppCommand {
//    let filter: AnyPublisher<(Date, Date), Never>
//    var token: SubscriptionToken
//
//    func execute(in store: AppStore) {
//      filter.setFailureType(to: NSError.self)
//        .map {
//          Persistences.Transaction(context: store.context)
//            .fetchPublisher(from: $0.0, to: $0.1)
//        }
//        .switchToLatest()
//        .sink(receiveCompletion: { completion in
//          if case .failure(let error) = completion {
//            print("error: \(error)")
//          }
//          self.token.unseal()
//        }, receiveValue: { value in
//          store.dispatch(.transactions(.loadAllDone(value)))
//        })
//        .seal(in: token)
//    }
//  }
//
//  struct CreateTransactionCommand: AppCommand {
//    let transaction: Alfheim.Transaction.Snapshot
//
//    func execute(in store: AppStore) {
//      let persistence = Persistences.Transaction(context: store.context)
//      let object = Alfheim.Transaction(context: store.context)
//      object.fill(transaction)
//
//      do {
//        try persistence.save()
//      } catch {
//        print("Update account failed: \(error)")
//      }
//    }
//  }
//
//  struct UpdateTransactionCommand: AppCommand {
//    let transaction: Alfheim.Transaction.Snapshot
//
//    func execute(in store: AppStore) {
//      let persistence = Persistences.Transaction(context: store.context)
//      if let object = persistence.transaction(withID: transaction.id) {
//        object.fill(transaction)
//      } else {
//        fatalError("Should not be here!")
//      }
//
//      do {
//        try persistence.save()
//      } catch {
//        print("Update transaction failed: \(error)")
//      }
//    }
//  }
//
//  struct DeleteTransactionCommand: AppCommand {
//    let transactions: [Alfheim.Transaction]
//
//    func execute(in store: AppStore) {
//      guard !transactions.isEmpty else {
//        return
//      }
//
//      let persistence = Persistences.Transaction(context: store.context)
//
//      for transaction in transactions {
//        delete(transaction, persistence: persistence)
//      }
//
//      do {
//        try persistence.save()
//      } catch {
//        print("Delete transaction failed: \(error)")
//      }
//    }
//
//    private func delete(_ transaction: Alfheim.Transaction, persistence: Persistences.Transaction) {
//      guard let object = persistence.transaction(withID: transaction.id) else {
//        fatalError("Should not be here!")
//      }
//      // object.fill(transaction)
//      persistence.delete(object)
//    }
//  }
//}
