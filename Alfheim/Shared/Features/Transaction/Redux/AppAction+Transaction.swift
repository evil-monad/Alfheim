//
//  AppAction+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppAction {
  enum Transaction {
    case updated([Alfheim.Transaction])
    case loadAll
    case loadAllDone([Alfheim.Transaction])

    case editTransaction(Alfheim.Transaction)
    case editTransactionDone

    case delete(in: [Alfheim.Transaction], at: IndexSet)
    case showStatistics([Alfheim.Transaction], interval: DateInterval)
    case dimissStatistics
  }
}
