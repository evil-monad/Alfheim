//
//  AccountGroup.swift
//  Domain
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

public extension Account {
  // (Income + Liabilities) + (Assets + Expenses) + Equity = 0
  enum Group: String {
    case assets
    case income
    case expenses
    case liabilities
    case equity
  }
}

public extension Account.Group {
  var name: String {
    rawValue
  }

  var balance: Bool {
    switch self {
    case .income, .expenses:
      return false
    default:
      return true
    }
  }

  var negative: Bool {
    switch self {
    case .assets:
      return false
    case .income:
      return true
    case .expenses:
      return false
    case .liabilities:
      return true
    case .equity:
      return false
    }
  }

  var positive: Bool {
    return !negative
  }
}
