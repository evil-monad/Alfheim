//
//  AppAction+Overview.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppAction {
  enum Overview {
    case toggleNewTransaction(presenting: Bool)
    case editTransaction(Alfheim.Transaction)
    case editTransactionDone
    case toggleStatistics(presenting: Bool)
    case toggleAccountDetail(presenting: Bool)
    case switchPeriod
    case toggleSettings(presenting: Bool)
    case onDetailed(Bool)

    case editor(Editor)
  }
}
