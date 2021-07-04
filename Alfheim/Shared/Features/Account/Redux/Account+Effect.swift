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
          .loaded(accounts)
        }
        .eraseToEffect()
    }

    static func delete(accounts: [Alfheim.Account], environment: AppEnvironment) -> Effect<Bool, NSError> {
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

    static func create(account: Alfheim.Account, environment: AppEnvironment) -> Effect<Bool, NSError> {
      guard let context = environment.context else {
        return Effect.none
      }

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
  }
}
