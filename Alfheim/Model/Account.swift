//
//  Account.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/3.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension Alne {
  struct Account {
    let id: String
    let name: String
    var description: String
    var tag: Tagit
    var group: Group
    var emoji: String

    enum Group: String {
      case assets
      case income
      case expenses
      case liabilities
      case equity

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
          return true
        case .income:
          return true
        case .expenses:
          return false
        case .liabilities:
          return false
        case .equity:
          return false
        }
      }

      var positive: Bool {
        return !negative
      }
    }
  }
}

extension Alne.Account {
  init(id: String,
       name: String,
       description: String,
       group: Group,
       tag: Tagit,
       emoji: String) {
    self.id = id
    self.name = name
    self.description = description
    self.group = group
    self.tag = tag
    self.emoji = emoji
  }
}

extension Alne.Account: Identifiable {}

extension Alne.Account: Hashable {}

extension Alne {
  enum Accounts {
    static var expenses: Account {
      Account(id: "_expenses",
              name: "Expenses",
              description: "Expenses account are where you spend money for (e.g. food).",
              group: .expenses,
              tag: "#FF2600",
              emoji: "💸")
    }

    static var income: Account {
      Account(id: "_income",
              name: "Income",
              description: "Income account are where you get money from (e.g. salary).",
              group: .income,
              tag: "#FF2600",
              emoji: "💰")
    }

    static var assets: Account {
      Account(id: "_assets",
              name: "Assets",
              description: "Assets represent the money you have (e.g. crash).",
              group: .assets,
              tag: "#FF2600",
              emoji: "💵")
    }

    static var liabilities: Account {
      Account(id: "_liabilities",
              name: "Liabilities",
              description: "Liabilities is what you owe somebody (e.g. credit card).",
              group: .liabilities,
              tag: "#FF2600",
              emoji: "💳")
    }

    static var equity: Account {
      Account(id: "_equity",
              name: "Equity",
              description: "Equity represents the value of something (e.g. existing assets).",
              group: .equity,
              tag: "#FF2600",
              emoji: "📈")
    }

    static var allCases: [Account] {
      [Accounts.expenses, Accounts.income, Accounts.assets, Accounts.liabilities, Accounts.equity]
    }
  }
}
