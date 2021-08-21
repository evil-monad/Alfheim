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
  case overview(id: UUID, action: Overview)
  //case editor(Editor)
//  case settings(Settings)
//  case transactions(Transactions)
//  case payment(Payment)
//  case catemoji(Catemoji)

//  case startImport
//  case finishImport

  // Account
  case load
  case didLoad([Alfheim.Account])
  case cleanup
  case addAccount(presenting: Bool)
  case editAccount(Alfheim.Account)
  case deleteAccount(Alfheim.Account)

  case newTransaction
  case accountEditor(AccountEditor)
}

extension AppAction {
  enum EditMode {
    case new
    case update
    case delete
  }
}
