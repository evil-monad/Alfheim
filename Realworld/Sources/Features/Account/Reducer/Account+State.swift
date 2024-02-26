//
//  AppState+Account.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import ComposableArchitecture

extension Account {
  @ObservableState
  struct State: Equatable {
    var accounts: [Domain.Account] = []

    var periods: [String: Period] = [:]
    var period: Period = .monthly
  }
}

extension Account.State {
  /// Transaction period
  enum Period {
    case weekly
    case monthly
    case yearly

    var display: String {
      switch self {
      case .weekly:
        return "this week"
      case .monthly:
        return "this month"
      case .yearly:
        return "this year"
      }
    }
  }

  enum Sorting: CaseIterable {
    case date
    case currency
  }
}
