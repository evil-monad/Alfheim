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
import Persistence
import Domain

extension Account {
  enum Effects {
    static func load(context: AppContext?) -> Effect<RealWorld.Action, Never> {
      guard let context = context else {
        return Effect.none
      }

      return Persistence.Account(context: context)
        .publisher
        .fetchAll()
        .replaceError(with: [])
        .map { accounts in
          .accountDidChange(Domain.Account.map(accounts))
        }
        .eraseToEffect()
    }

    static func fetchAll(context: AppContext?, on queue: AnySchedulerOf<DispatchQueue>) -> Effect<App.Action, Never> {
      guard let context = context else {
        return Effect.none
      }

      return Effect<[Database.Account], Never>.task {
        guard let accounts = try? await Persistence.Account(context: context) .fetchAll() else {
          return []
        }
        return accounts
      }
      .receive(on: queue)
      .eraseToEffect()
      .map { App.Action.accountDidFetch(Domain.Account.map($0)) }
    }

    static func delete(accounts: [Domain.Account], context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistence.Account(context: context)
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

    static func create(snapshot: Domain.Account, context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let object = Database.Account(context: context)
      object.fill(snapshot)

      return create(account: object, context: context)
    }

    static func create(account: Database.Account, context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      return create(account: account, context: context)
    }

    static func create(account: Database.Account, context: AppContext) -> Effect<Bool, NSError> {
      let persistence = Persistence.Account(context: context)

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

    static func update(snapshot: Domain.Account, context: AppContext?) -> Effect<Bool, NSError> {
      guard let context = context else {
        return Effect.none
      }

      let persistence = Persistence.Account(context: context)
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

    static func loadAccounts(context: AppContext?) -> Effect<EditAccount.Action, Never> {
      guard let context = context else {
        return Effect.none
      }

      return Persistence.Account(context: context)
        .publisher
        .fetchAll()
        .replaceError(with: [])
        .map {
          .didLoadAccounts(Domain.Account.map($0))
        }
        .eraseToEffect()
    }
  }
}
