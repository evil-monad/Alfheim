//
//  AppAction.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Domain

extension RealWorld {
  enum Action {
    case lifecycle(SceneLifecycleEvent)
    //case overview(index: Int, action: Overview)
    case overview(Overview.Action)
    case selectAccount(id: UUID?)
    //case editor(Editor)
    //  case settings(Settings)
    //  case transactions(Transactions)
    //  case payment(Payment)
    //  case catemoji(Catemoji)

    //  case startImport
    //  case finishImport

    // Account
    case loadAll
    case accountDidChange([Domain.Account])
    case fetchAccounts
    case accountDidFetch([Domain.Account])
    case cleanup

    // Transaction
    case transactionDidChange([Domain.Transaction])

    case addAccount(presenting: Bool)
    case editAccount(presenting: Bool, Domain.Account?)
    case deleteAccount(Domain.Account)

    case newTransaction
    case accountEditor(AccountEdit.Action)

    case selectMenu(selection: Int?)
    case transaction(Transaction.Action)

    // settings
    case settings(Settings.Action)
  }
}

extension RealWorld.Action {
  enum EditMode {
    case new
    case update
    case delete
  }
}
