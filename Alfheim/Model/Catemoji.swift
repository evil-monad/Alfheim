//
//  Catemoji.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/1.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension Alne {
  struct Catemoji {
    let category: Category
    let emoji: String

    static let uncleared = Catemoji(category: .uncleared, emoji: Alne.Uncleared.uncleared.emoji)
  }
}

extension Alne.Catemoji: Hashable {}

enum Category: String, CaseIterable {
  case uncleared
  case food
  case drink
  case fruit
  case clothes
  case household
  case personal
  case transportation
  case services

  var name: String {
    rawValue
  }

  var text: String {
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
extension Alne {
  enum Food: String, CaseIterable {
    case groceries = "🛒"
    case eating = "🍽"
    case snacks = "🍟"
    case pizza = "🍕"
    case pasta = "🍝"
    case rice = "🍚"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .food
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Fruit: String, CaseIterable {
    case apple = "🍎"
    case banana = "🍌"
    case grapes = "🍇"
    case cherries = "🍒"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .fruit
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Drink: String, CaseIterable {
    case beer = "🍻"
    case milk = "🥛"
    case tea = "🍵"
    case wine = "🍷"
    case coffee = "☕️"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .drink
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Clothes: String, CaseIterable {
    case shirt = "👕"
    case pants = "👖"
    case sock = "🧦"
    case coat = "🧥"
    case skirt = "👗"
    case shoes = "👟"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .clothes
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Household: String, CaseIterable {
    case goods = "🧺"
    case love = "👩‍❤️‍👨"
    case travel = "🏖"
    case object = "💡"
    case house = "🏡"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .household
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Personal: String, CaseIterable {
    case health = "💊"
    case privacy = "🔏"
    case movie = "🎬"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .personal
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Transportation: String, CaseIterable {
    case taxi = "🚕"
    case car = "🚘"
    case airplane = "✈️"
    case bus = "🚙"
    case metro = "🚇"
    case train = "🚄"
    case boat = "🛳"
    case bike = "🚲"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .transportation
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Services: String, CaseIterable {
    case subscription = "🌐"
    case mobile = "📱"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .services
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }

  enum Uncleared: String, CaseIterable {
    case uncleared = "💰"

    var emoji: String {
      rawValue
    }

    var category: Category {
      .uncleared
    }

    static var catemojis: [Catemoji] {
      allCases.map { Catemoji(category: $0.category, emoji: $0.emoji) }
    }
  }
}
