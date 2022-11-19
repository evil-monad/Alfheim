//
//  AccountEditor+Action.swift
//  AccountEditor+Action
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Domain

extension AccountEdit {
  enum Action {
    case save(Domain.Account, mode: App.Action.EditMode)
    case edit(Domain.Account)
    case new
    case changed(Field)
    case loadAccounts
    case didLoadAccounts([Domain.Account])

    enum Field {
      case name(String)
      case introduction(String)
      case currency(Currency)
      case parent(Domain.Account.Summary?)
      case tag(String)
      case emoji(String?)
    }
  }
}
