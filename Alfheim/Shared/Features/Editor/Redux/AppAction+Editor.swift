//
//  AppAction+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppAction {
  enum Editor {
    case save(Alfheim.Transaction.Snapshot, mode: EditMode)
    case edit(Alfheim.Transaction)
    case new
    case changed(Field)
    case loadAccounts
    case didLoadAccounts([Alfheim.Account])

    enum Field {
      case amount(String)
      case currency(Currency)
      case source(Alfheim.Account?)
      case target(Alfheim.Account?)
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
