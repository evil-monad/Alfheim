//
//  Category.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/28.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import Foundation

public enum Category: String, CaseIterable {
  case uncleared
  case food
  case drink
  case fruit
  case clothes
  case household
  case personal
  case transportation
  case services

  public var name: String {
    rawValue
  }

  public var text: String {
    switch self {
    case .food:
      return "🍔"
    case .drink:
      return "🥤"
    case .fruit:
      return "🍎"
    case .clothes:
      return "👔"
    case .household:
      return "🏠"
    case .personal:
      return "🤷‍♂️"
    case .transportation:
      return "🚘"
    case .services:
      return "🌐"
    case .uncleared:
      return "👀"
    }
  }
}

/// Build in catemojis
public enum Food: String, CaseIterable {
  case groceries = "🛒"
  case eating = "🍽"
  case snacks = "🍟"
  case pizza = "🍕"
  case pasta = "🍝"
  case rice = "🍚"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .food
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Fruit: String, CaseIterable {
  case apple = "🍎"
  case banana = "🍌"
  case grapes = "🍇"
  case cherries = "🍒"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .fruit
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Drink: String, CaseIterable {
  case beer = "🍻"
  case milk = "🥛"
  case tea = "🍵"
  case wine = "🍷"
  case coffee = "☕️"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .drink
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Clothes: String, CaseIterable {
  case shirt = "👕"
  case pants = "👖"
  case sock = "🧦"
  case coat = "🧥"
  case skirt = "👗"
  case shoes = "👟"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .clothes
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Household: String, CaseIterable {
  case goods = "🧺"
  case love = "👩‍❤️‍👨"
  case travel = "🏖"
  case object = "💡"
  case house = "🏡"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .household
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Personal: String, CaseIterable {
  case health = "💊"
  case privacy = "🔏"
  case movie = "🎬"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .personal
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Transportation: String, CaseIterable {
  case taxi = "🚕"
  case car = "🚘"
  case airplane = "✈️"
  case bus = "🚙"
  case metro = "🚇"
  case train = "🚄"
  case boat = "🛳"
  case bike = "🚲"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .transportation
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Services: String, CaseIterable {
  case subscription = "🌐"
  case mobile = "📱"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .services
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}

public enum Uncleared: String, CaseIterable {
  case uncleared = "💰"

  public var emoji: String {
    rawValue
  }

  public var category: Category {
    .uncleared
  }

  public static var catemojis: [Catemoji] {
    allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
  }
}
