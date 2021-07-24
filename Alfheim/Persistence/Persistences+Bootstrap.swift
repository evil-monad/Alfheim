//
//  Persistences+Bootstrap.swift
//  Alfheim
//
//  Created by alex.huo on 2021/7/24.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

extension Persistences {
  struct Bootstrap {
    let context: NSManagedObjectContext

    func start() throws {
      // Creating default accounts
      let expenses = Alfheim.Account(context: context)
      expenses.id = UUID()
      expenses.name = "Expenses"
      expenses.introduction = "Expenses account are where you spend money for (e.g. food)."
      expenses.group = "expenses"
      expenses.currency = Int16(0)
      expenses.tag = "#FF2600"
      expenses.emoji = "💸"

      let income = Alfheim.Account(context: context)
      income.id = UUID()
      income.name = "Income"
      income.introduction = "Income account are where you get money from (e.g. salary)."
      income.group = "income"
      income.currency = Int16(0)
      income.emoji = "💰"
      income.tag = "#FF2600"

      let assets = Alfheim.Account(context: context)
      assets.id = UUID()
      assets.name = "Assets"
      assets.introduction = "Assets represent the money you have (e.g. crash)."
      assets.group = "assets"
      assets.currency = Int16(0)
      assets.emoji = "💵"
      assets.tag = "#FF2600"

      let liabilities = Alfheim.Account(context: context)
      liabilities.id = UUID()
      liabilities.name = "Liabilities"
      liabilities.introduction = "Liabilities is what you owe somebody (e.g. credit card)."
      liabilities.group = "liabilities"
      liabilities.currency = Int16(0)
      liabilities.emoji = "💳"
      liabilities.tag = "#FF2600"

      let equity = Alfheim.Account(context: context)
      equity.id = UUID()
      equity.name = "Equity"
      equity.introduction = "Equity represents the value of something (e.g. existing assets)."
      equity.group = "equity"
      equity.currency = Int16(0)
      equity.emoji = "📈"
      equity.tag = "#FF2600"

      // Catemoji
      buildinCatemojis().forEach {
        let emoji = Alfheim.Emoji(context: context)
        emoji.category = $0.category.name
        emoji.text = $0.emoji
      }

      try context.save()
    }

    func migrate() {
    }
  }
}

extension Persistences.Bootstrap {
  private func buildinCatemojis() -> [Catemoji] {
    Alne.Food.catemojis + Alne.Drink.catemojis + Alne.Fruit.catemojis + Alne.Clothes.catemojis + Alne.Household.catemojis + Alne.Personal.catemojis + Alne.Transportation.catemojis + Alne.Services.catemojis + Alne.Uncleared.catemojis
  }
}
