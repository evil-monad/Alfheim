//
//  AppAction+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain

extension AppAction {
  enum Editor {
    case save(Domain.Transaction, mode: EditMode)
    case edit(Domain.Transaction)
    case new
    case changed(Field)
    case loadAccounts
    case didLoadAccounts([Domain.Account])
    case focused(AppState.Editor.FocusField?)

    enum Field {
      case amount(String)
      case currency(Currency)
      case source(Domain.Account.Summary?)
      case target(Domain.Account.Summary?)
      case date(Date)
      case notes(String)
      case payee(String?)
      case number(String?)
      case repeated(Repeat)
      case cleared(Bool)
      case attachment
    }
  }
}
