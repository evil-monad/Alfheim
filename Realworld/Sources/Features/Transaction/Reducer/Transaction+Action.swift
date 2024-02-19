//
//  AppAction+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import ComposableArchitecture

extension Transaction {
  @CasePathable
  public enum Action: Equatable {
    case editTransaction(Domain.Transaction)
    case didEditTransaction

    case delete(Domain.Transaction)
    case toggleFlag(Domain.Transaction)
    case showStatistics([Domain.Transaction], interval: DateInterval)
    case dimissStatistics

    case filtered(Transaction.State.Filter)

    case onAppear

    case transactionsDidChange([Domain.Transaction])
    case accountDidChange(Domain.Account)
  }
}
