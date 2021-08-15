//
//  AccountEditor+Action.swift
//  AccountEditor+Action
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension AppAction {
  enum AccountEditor {
    case save(Alfheim.Account.Snapshot, mode: EditMode)
    case edit(Alfheim.Account)
    case new
    case changed(Field)
    case loadAccounts
    case didLoadAccounts([Alfheim.Account])

    enum Field {
      case name(String)
      case introduction(String)
      case currency(Currency)
      case parent(Alfheim.Account?)
      case tag(String?)
      case emoji(String?)
    }
  }
}
