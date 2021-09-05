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
    case fetch
    case didChange([Alfheim.Transaction])
    case loadAll
    case didLoadAll([Alfheim.Transaction])

    case editTransaction(Alfheim.Transaction)
    case didEditTransaction

    // case delete(in: [Alfheim.Transaction], at: IndexSet)
    case delete(Alfheim.Transaction)
    case flag(Alfheim.Transaction)
    case showStatistics([Alfheim.Transaction], interval: DateInterval)
    case dimissStatistics
  }
}
