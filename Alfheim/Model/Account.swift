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
    var emoji: String?
    let currency: Currency

    enum Group: String {
      case assets
      case income
      case expenses
      case liabilities
      case equity
    }
  }
}

extension Alne.Account {
  init(id: String, name: String, description: String, tag: Tagit, group: Group, currency: Currency = .cny, emoji: String? = nil) {
    self.id = id
    self.name = name
    self.description = description
    self.tag = tag
    self.group = group
    self.emoji = emoji
    self.currency = currency
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
              tag: "#FF2600",
              group: .expenses)
    }

    static var income: Account {
      Account(id: "_income",
              name: "Income",
              description: "Income account are where you get money from (e.g. salary).",
              tag: "",
              group: .income)
    }

    static var assets: Account {
      Account(id: "_assets",
              name: "Assets",
              description: "Assets represent the money you have (e.g. crash).",
              tag: "",
              group: .assets)
    }

    static var liabilities: Account {
      Account(id: "_liabilities",
              name: "Liabilities",
              description: "Liabilities is what you owe somebody (e.g. credit card).",
              tag: "",
              group: .liabilities)
    }

    static var equity: Account {
      Account(id: "_equity",
              name: "Equity",
              description: "Equity represents the value of something (e.g. existing assets).",
              tag: "",
              group: .equity)
    }

    static var allCases: [Account] {
      [Accounts.expenses, Accounts.income, Accounts.assets, Accounts.liabilities, Accounts.equity]
    }
  }
}