//
//  Persistences+Bootstrap.swift
//  Alfheim
//
//  Created by alex.huo on 2021/7/24.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Kit
import Alne
import CoreData
import Database
import Domain

public struct Bootstrap {
  public let context: NSManagedObjectContext

  public init(context: NSManagedObjectContext) {
    self.context = context
  }

  /// Setup default accounts
  public func start() throws {
    // Creating default accounts

    func expenses() {
      let group = Domain.Account.Group.expenses.rawValue
      let expenses = Database.Account(context: context)
      expenses.id = UUID()
      expenses.name = "Expenses"
      expenses.introduction = "Expenses account are where you spend money for (e.g. food)."
      expenses.group = group
      expenses.currency = Int16(0)
      expenses.tag = Tagit.red.rawValue
      expenses.emoji = "💸"

      let food = Database.Account(context: context)
      food.id = UUID()
      food.name = "Food"
      food.introduction = "Food account are where you spend money for (e.g. apple)."
      food.group = group
      food.currency = Int16(0)
      food.tag = Tagit.pink.rawValue
      food.emoji = "🍔"
      food.parent = expenses

      let drink = Database.Account(context: context)
      drink.id = UUID()
      drink.name = "Drink"
      drink.introduction = "Drink account are where you spend money for (e.g. milk)."
      drink.group = group
      drink.currency = Int16(0)
      drink.tag = Tagit.grape.rawValue
      drink.emoji = "🍹"
      drink.parent = expenses

      let entertainment = Database.Account(context: context)
      entertainment.id = UUID()
      entertainment.name = "Entertainment"
      entertainment.introduction = "Entertainment account are where you spend money for (e.g. Movie)."
      entertainment.group = group
      entertainment.currency = Int16(0)
      entertainment.tag = Tagit.violet.rawValue
      entertainment.emoji = "🕹"
      entertainment.parent = expenses
    }

    func income() {
      let group = Domain.Account.Group.income.rawValue
      let income = Database.Account(context: context)
      income.id = UUID()
      income.name = "Income"
      income.introduction = "Income account are where you get money from (e.g. salary)."
      income.group = group
      income.currency = Int16(0)
      income.emoji = "💰"
      income.tag = Tagit.indigo.rawValue

      let salary = Database.Account(context: context)
      salary.id = UUID()
      salary.name = "Salary"
      salary.introduction = "Salary account are where you get money from (e.g. salary)."
      salary.group = group
      salary.currency = Int16(0)
      salary.emoji = "💰"
      salary.tag = Tagit.blue.rawValue
      salary.parent = income
    }

    func assets() {
      let group = Domain.Account.Group.assets.rawValue
      let assets = Database.Account(context: context)
      assets.id = UUID()
      assets.name = "Assets"
      assets.introduction = "Assets represent the money you have (e.g. cash)."
      assets.group = group
      assets.currency = Int16(0)
      assets.emoji = "💵"
      assets.tag = Tagit.cyan.rawValue

      let checking = Database.Account(context: context)
      checking.id = UUID()
      checking.name = "Checking"
      checking.introduction = "Checking represent the money you have."
      checking.group = group
      checking.currency = Int16(0)
      checking.emoji = "💳"
      checking.tag = Tagit.alfheim.rawValue
      checking.parent = assets

      let cash = Database.Account(context: context)
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
      let group = Domain.Account.Group.liabilities.rawValue
      let liabilities = Database.Account(context: context)
      liabilities.id = UUID()
      liabilities.name = "Liabilities"
      liabilities.introduction = "Liabilities is what you owe somebody (e.g. credit card)."
      liabilities.group = group
      liabilities.currency = Int16(0)
      liabilities.emoji = "💳"
      liabilities.tag = Tagit.green.rawValue

      let credit = Database.Account(context: context)
      credit.id = UUID()
      credit.name = "Credit Card"
      credit.introduction = "Credit card is what you owe somebody (e.g. credit card)."
      credit.group = group
      credit.currency = Int16(0)
      credit.emoji = "💳"
      credit.tag = Tagit.lime.rawValue
      credit.parent = liabilities
    }

    func equity() {
      let group = Domain.Account.Group.equity.rawValue
      let equity = Database.Account(context: context)
      equity.id = UUID()
      equity.name = "Equity"
      equity.introduction = "Equity represents the value of something (e.g. existing assets)."
      equity.group = group
      equity.currency = Int16(0)
      equity.emoji = "📈"
      equity.tag = Tagit.yellow.hex

      let opening = Database.Account(context: context)
      opening.id = UUID()
      opening.name = "Opening Balance"
      opening.introduction = "Opening balance represents the value of something (e.g. existing assets)."
      opening.group = group
      opening.currency = Int16(0)
      opening.emoji = "📈"
      opening.tag = Tagit.orange.rawValue
      opening.parent = equity
    }

    expenses()
    income()
    assets()
    liabilities()
    equity()

    // Catemoji
    buildinCatemojis().forEach {
      let emoji = Database.Emoji(context: context)
      emoji.category = $0.category.name
      emoji.text = $0.emoji
    }

    try context.save()
  }

  func migrate() {
  }
}

extension Bootstrap {
  private func buildinCatemojis() -> [Alne.Catemoji] {
    Alne.Food.catemojis + Alne.Drink.catemojis + Alne.Fruit.catemojis + Alne.Clothes.catemojis + Alne.Household.catemojis + Alne.Personal.catemojis + Alne.Transportation.catemojis + Alne.Services.catemojis + Alne.Uncleared.catemojis
  }
}
