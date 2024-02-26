//
//  AppAction+Overview.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import ComposableArchitecture

extension Overview {
  @CasePathable
  public enum Action: Equatable {
    case onAppear
    case toggleNewTransaction(presenting: Bool)
    case editTransaction(Domain.Transaction)
    case editTransactionDone
    case toggleStatistics(presenting: Bool)
    case toggleAccountDetail(presenting: Bool)
    case switchPeriod
    case toggleSettings(presenting: Bool)
    case onDetailed(Bool)

    case accountDidChange(Domain.Account)
    case editor(Editor.Action)
    case transaction(Transaction.Action)
  }
}
