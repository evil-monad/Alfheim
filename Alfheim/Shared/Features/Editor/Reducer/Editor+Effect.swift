//
//  AppEffect+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/8.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture
import Domain
import Persistence

extension Editor {
  enum Effects {
    static func loadAccounts(context: AppContext?) -> EffectTask<Editor.Action> {
      guard let context = context else {
        return .none
      }

      return Persistence.Account(context: context)
        .publisher
        .fetchAll()
        .replaceError(with: [])
        .map {
          .didLoadAccounts(Domain.Account.mapAccounts($0))
        }
        .eraseToEffect()
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
  }
}
