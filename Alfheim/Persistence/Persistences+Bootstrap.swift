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

      func expenses() {
        let group = Alne.Account.Group.expenses.rawValue
        let expenses = Alfheim.Account(context: context)
        expenses.id = UUID()
        expenses.name = "Expenses"
        expenses.introduction = "Expenses account are where you spend money for (e.g. food)."
        expenses.group = group
        expenses.currency = Int16(0)
        expenses.tag = Tagit.red.hex
        expenses.emoji = "💸"

        let food = Alfheim.Account(context: context)
        food.id = UUID()
        food.name = "Food"
        food.introduction = "Food account are where you spend money for (e.g. apple)."
        food.group = group
        food.currency = Int16(0)
        food.tag = Tagit.pink.hex
        food.emoji = "🍔"
        food.parent = expenses

        let drink = Alfheim.Account(context: context)
        drink.id = UUID()
        drink.name = "Drink"
        drink.introduction = "Drink account are where you spend money for (e.g. milk)."
        drink.group = group
        drink.currency = Int16(0)
        drink.tag = Tagit.grape.hex
        drink.emoji = "🍹"
        drink.parent = expenses

        let entertainment = Alfheim.Account(context: context)
        entertainment.id = UUID()
        entertainment.name = "Entertainment"
        entertainment.introduction = "Entertainment account are where you spend money for (e.g. Movie)."
        entertainment.group = group
        entertainment.currency = Int16(0)
        entertainment.tag = Tagit.violet.hex
        entertainment.emoji = "🕹"
        entertainment.parent = expenses
      }

      func income() {
        let group = Alne.Account.Group.income.rawValue
        let income = Alfheim.Account(context: context)
        income.id = UUID()
        income.name = "Income"
        income.introduction = "Income account are where you get money from (e.g. salary)."
        income.group = group
        income.currency = Int16(0)
        income.emoji = "💰"
        income.tag = Tagit.indigo.hex

        let salary = Alfheim.Account(context: context)
        salary.id = UUID()
        salary.name = "Salary"
        salary.introduction = "Salary account are where you get money from (e.g. salary)."
        salary.group = group
        salary.currency = Int16(0)
        salary.emoji = "💰"
        salary.tag = Tagit.blue.hex
        salary.parent = income
      }

      func assets() {
        let group = Alne.Account.Group.assets.rawValue
        let assets = Alfheim.Account(context: context)
        assets.id = UUID()
        assets.name = "Assets"
        assets.introduction = "Assets represent the money you have (e.g. cash)."
        assets.group = group
        assets.currency = Int16(0)
        assets.emoji = "💵"
        assets.tag = Tagit.cyan.hex

        let cash = Alfheim.Account(context: context)
        cash.id = UUID()
        cash.name = "Cash"
        cash.introduction = "Cash represent the money you have (e.g. cash)."
        cash.group = group
        cash.currency = Int16(0)
        cash.emoji = "💵"
        cash.tag = Tagit.teal.hex
        cash.parent = assets
      }

      func liabilities() {
        let group = Alne.Account.Group.liabilities.rawValue
        let liabilities = Alfheim.Account(context: context)
        liabilities.id = UUID()
        liabilities.name = "Liabilities"
        liabilities.introduction = "Liabilities is what you owe somebody (e.g. credit card)."
        liabilities.group = group
        liabilities.currency = Int16(0)
        liabilities.emoji = "💳"
        liabilities.tag = Tagit.green.hex

        let credit = Alfheim.Account(context: context)
        credit.id = UUID()
        credit.name = "Credit Card"
        credit.introduction = "Credit card is what you owe somebody (e.g. credit card)."
        credit.group = group
        credit.currency = Int16(0)
        credit.emoji = "💳"
        credit.tag = Tagit.lime.hex
        credit.parent = liabilities
      }

      func equity() {
        let group = Alne.Account.Group.equity.rawValue
        let equity = Alfheim.Account(context: context)
        equity.id = UUID()
        equity.name = "Equity"
        equity.introduction = "Equity represents the value of something (e.g. existing assets)."
        equity.group = group
        equity.currency = Int16(0)
        equity.emoji = "📈"
        equity.tag = Tagit.yellow.hex

        let opening = Alfheim.Account(context: context)
        opening.id = UUID()
        opening.name = "Opening Balance"
        opening.introduction = "Opening balance represents the value of something (e.g. existing assets)."
        opening.group = group
        opening.currency = Int16(0)
        opening.emoji = "📈"
        opening.tag = Tagit.orange.hex
        opening.parent = equity
      }
      
      expenses()
      income()
      assets()
      liabilities()
      equity()

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