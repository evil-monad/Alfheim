//
//  AppEffect+Account.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture
import CoreData
import Database
import Domain

extension AppEffects {
  enum Account {
    static func load(environment: AppEnvironment) -> Effect<AppAction, Never> {
      guard let context = environment.context else {
        return Effect.none
      }

      return Persistences.Account(context: context)
        .fetchAllPublisher()
        .replaceError(with: [])
        .map { accounts in
          .accountDidChange(Domain.Account.mapAccounts(accounts))
        }
        .eraseToEffect()
    }

    static func delete(accounts: [Domain.Account], environment: AppEnvironment) -> Effect<Bool, NSError> {
      guard let context = environment.context else {
        return Effect.none
      }

      let persistence = Persistences.Account(context: context)
      for account in accounts {
        if let object = persistence.account(withID: account.id) {
          persistence.delete(object)
        }
      }

      // TBD: Thread safe?
      return Future { promise in
        do {
          try persistence.save()
          promise(.success(true))
        } catch {
          print("Update account failed: \(error)")
          promise(.failure(error as NSError))
        }
      }
      .eraseToEffect()
    }

    static func create(snapshot: Domain.Account, environment: AppEnvironment.Account) -> Effect<Bool, NSError> {
      guard let context = environment.context else {
        return Effect.none
      }

      let object = Database.Account(context: context)
      object.fill(snapshot)

      return create(account: object, context: context)
    }

    static func create(account: Database.Account, environment: AppEnvironment) -> Effect<Bool, NSError> {
      guard let context = environment.context else {
        return Effect.none
      }

      return create(account: account, context: context)
    }

    static func create(account: Database.Account, context: NSManagedObjectContext) -> Effect<Bool, NSError> {
      let persistence = Persistences.Account(context: context)

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

    static func update(snapshot: Domain.Account, environment: AppEnvironment.Account) -> Effect<Bool, NSError> {
      guard let context = environment.context else {
        return Effect.none
      }

      let persistence = Persistences.Account(context: context)
      if let object = persistence.account(withID: snapshot.id) {
        object.fill(snapshot)
        if let id = snapshot.parent?.id, let parent = persistence.account(withID: id) {
          object.fill(parent: parent)
        }
      } else {
        fatalError("Should not be here!")
      }

      return Future { promise in
        do {
          try persistence.save()
          promise(.success(true))
        } catch {
          print("Update account failed: \(error)")
          promise(.failure(error as NSError))
        }
      }
      .eraseToEffect()
    }

    static func loadAccounts(environment: AppEnvironment.Account) -> Effect<AppAction.AccountEditor, Never> {
      guard let context = environment.context else {
        return Effect.none
      }

      return Persistences.Account(context: context)
        .fetchAllPublisher()
        .replaceError(with: [])
        .map {
          .didLoadAccounts(Domain.Account.mapAccounts($0))
        }
        .eraseToEffect()
    }
  }
}
