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
    case lifecycle(SceneLifecycleEvent)
    //case overview(index: Int, action: Overview)
    case overview(Overview.Action)
    //case editor(Editor)
    //  case settings(Settings)
    //  case transactions(Transactions)
    //  case catemoji(Catemoji)

    //  case startImport
    //  case finishImport

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

    case addAccount(presenting: Bool)
    case account(presenting: Bool, Domain.Account?)
    case deleteAccount(Domain.Account)

    case newTransaction
    case editAccount(EditAccount.Action)

    case selectMenu(Home.MenuItem?)
    case transaction(Transaction.Action)

    // settings
    case settings(Settings.Action)

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
