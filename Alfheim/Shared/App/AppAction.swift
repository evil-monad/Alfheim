//
//  AppAction.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import ComposableArchitecture

extension RealWorld {
  enum Action {
    case lifecycle(SceneLifecycle.Action)

    case main(Main.Action)

    // home
    case home(Home.Action)

    // Account
    case loadAll
    case accountDidChange([Domain.Account])
    case fetchAccounts
    case accountDidFetch([Domain.Account])
    case cleanup

    // Transaction
    case transactionDidChange([Domain.Transaction])

    case newTransaction

    // navigation path
    case path(StackAction<Path.State, Path.Action>)
  }
}

extension RealWorld.Action {
  enum EditMode: Equatable {
    case new
    case update
    case delete
  }
}
