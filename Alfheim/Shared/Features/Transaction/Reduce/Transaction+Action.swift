//
//  AppAction+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain

extension Transaction {
  enum Action: Equatable {
    case editTransaction(Domain.Transaction)
    case didEditTransaction

    case delete(id: UUID)
    case toggleFlag(flag: Bool, id: UUID)
    case showStatistics([Domain.Transaction], interval: DateInterval)
    case dimissStatistics

    case filter(selection: Transaction.State.Filter)
  }
}
