//
//  AppAction.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

enum AppAction {
  case overview(index: Int, action: Overview)
  //case editor(Editor)
//  case settings(Settings)
//  case transactions(Transactions)
//  case payment(Payment)
//  case catemoji(Catemoji)

//  case startImport
//  case finishImport

  case load
  case loaded([Alfheim.Account])
  case cleanup
  case new
}

extension AppAction {
  enum EditMode {
    case new
    case update
    case delete
  }
}
