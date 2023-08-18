//
//  EditAccount+Action.swift
//  Alfheim
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Domain

extension EditAccount {
  public enum Action: Equatable {
    case save(Domain.Account, mode: App.Action.EditMode)
    case edit(Domain.Account)
    case new
    case changed(Field)
    case loadAccounts
    case didLoadAccounts([Domain.Account])

    public enum Field: Equatable {
      case name(String)
      case introduction(String)
      case currency(Currency)
      case parent(Domain.Account.Summary?)
      case tag(String)
      case emoji(String?)
    }

    public enum Delegate: Equatable {
      case dismiss
      case saved
    }

    case delegate(Delegate)
  }
}
