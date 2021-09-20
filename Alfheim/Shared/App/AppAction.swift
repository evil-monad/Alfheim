//
//  AppAction.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

enum AppAction {
  //case overview(index: Int, action: Overview)
  case overview(Overview)
  case selectAccount(id: UUID?)
  //case editor(Editor)
//  case settings(Settings)
//  case transactions(Transactions)
//  case payment(Payment)
//  case catemoji(Catemoji)

//  case startImport
//  case finishImport

  // Account
  case load
  case accountDidChange([Alfheim.Account])
  case cleanup

  // Transaction
  case transactionDidChange([Alfheim.Transaction])

  case addAccount(presenting: Bool)
  case editAccount(presenting: Bool, Alfheim.Account?)
  case deleteAccount(Alfheim.Account)

  case newTransaction
  case accountEditor(AccountEditor)

  case selectMenu(selection: Int?)
  case transaction(Transaction)

  // settings
  case settings(Settings)
}

extension AppAction {
  enum EditMode {
    case new
    case update
    case delete
  }
}
