//
//  Catemoji.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/1.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

protocol CategoryEmojiRepresentable {
  var category: String { get }
  var emoji: String { get }
}

extension Alne {
  struct Catemoji: CategoryEmojiRepresentable {
    let category: String
    let emoji: String
  }
}

extension Alne.Catemoji: Hashable {}

extension Alne {
  /// Category emoji
  enum Catemojis: CategoryEmojiRepresentable {
    case food(Food)
    case fruit(Fruit)
    case drink(Drink)
    case clothes(Clothes)
    case household(Household)
    case transportation(Transportation)
    case personal(Personal)
    case uncleared(Uncleared)
    case custom(String)

    var emoji: String {
      switch self {
      case .food(let food):
        return food.emoji
      case .fruit(let fruit):
        return fruit.emoji
      case .drink(let drink):
        return drink.emoji
      case .clothes(let clothes):
        return clothes.emoji
      case .household(let household):
        return household.emoji
      case .transportation(let transport):
        return transport.emoji
      case .personal(let personal):
        return personal.emoji
      case .uncleared(let uncleared):
        return uncleared.emoji
      case .custom(let emoji):
        return emoji
      }
    }

    var category: String {
      switch self {
      case .food(let food):
        return food.category
      case .fruit(let fruit):
        return fruit.category
      case .drink(let drink):
        return drink.category
      case .clothes(let clothes):
        return clothes.category
      case .household(let household):
        return household.category
      case .transportation(let transportation):
        return transportation.category
      case .personal(let personal):
        return personal.category
      case .uncleared(let uncleared):
        return uncleared.category
      case .custom:
        return "Custom"
      }
    }

    var allCases: [Catemojis] {
      switch self {
      case .food:
        return Food.allCases.map { .food($0) }
      case .fruit:
        return Fruit.allCases.map { .fruit($0) }
      case .drink:
        return Drink.allCases.map { .drink($0) }
      case .clothes:
        return Clothes.allCases.map { .clothes($0) }
      case .household:
        return Household.allCases.map { .household($0) }
      case .transportation:
        return Transportation.allCases.map { .transportation($0) }
      case .personal:
        return Personal.allCases.map { .personal($0) }
      case .uncleared:
        return Uncleared.allCases.map { .uncleared($0) }
      case .custom(let emoji):
        return [Catemojis.custom(emoji)]
      }
    }

    /// All categories
    static var allCates: [Catemojis] {
      [.food(.others), .fruit(.others), .drink(.others), .clothes(.others), .household(.others), .transportation(.others), .personal(.others), .uncleared(.uncleared)]
    }

    static var allCases: [Catemojis] {
      allCates.flatMap { $0.allCases }
    }
  }
}


extension Catemojis {
  enum Food: String, CaseIterable, CategoryEmojiRepresentable {
    case groceries = "🛒"
    case eating = "🍽"
    case snacks = "🍟"
    case others = "🍔"

    var catemoji: Catemojis {
      .food(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Food"
    }
  }

  enum Fruit: String, CaseIterable, CategoryEmojiRepresentable {
    case apple = "🍎"
    case banana = "🍌"
    case grapes = "🍇"
    case cherries = "🍒"
    case others = "🍓"

    var catemoji: Catemojis {
      .fruit(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Fruit"
    }
  }

  enum Drink: String, CaseIterable, CategoryEmojiRepresentable {
    case beer = "🍻"
    case milk = "🥛"
    case tea = "🥤"
    case wine = "🍷"
    case others = "🍹"

    var catemoji: Catemojis {
      .drink(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Drink"
    }
  }

  enum Clothes: String, CaseIterable, CategoryEmojiRepresentable {
    case shirt = "👕"
    case pants = "👖"
    case sock = "🧦"
    case coat = "🧥"
    case skirt = "👗"
    case others = "👔"

    var catemoji: Catemojis {
      .clothes(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Clothes"
    }
  }

  enum Household: String, CaseIterable, CategoryEmojiRepresentable {
    case goods = "🧺"
    case love = "👩‍❤️‍👨"
    case travel = "🏖"
    case object = "💡"
    case others = "🏠"

    var catemoji: Catemojis {
      .household(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Household"
    }
  }

  enum Personal: String, CaseIterable, CategoryEmojiRepresentable {
    case health = "💊"
    case privacy = "🔏"
    case services = "🌐"
    case others = "🤷‍♂️"

    var catemoji: Catemojis {
      .personal(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Personal"
    }
  }

  enum Transportation: String, CaseIterable, CategoryEmojiRepresentable {
    case taxi = "🚕"
    case car = "🚘"
    case airplane = "✈️"
    case bus = "🚙"
    case metro = "🚇"
    case train = "🚄"
    case boat = "🛳"
    case others = "🚲"

    var catemoji: Catemojis {
      .transportation(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Transportation"
    }
  }

  enum Uncleared: String, CaseIterable, CategoryEmojiRepresentable {
    case uncleared = "🧚‍♀️"

    var catemoji: Catemojis {
      .uncleared(self)
    }

    var emoji: String {
      rawValue
    }

    var category: String {
      "Uncleared"
    }
  }
}

extension Catemojis {
  init(_ emoji: String) {
    switch emoji {
    case Food.groceries.emoji:
      self = .food(.groceries)
    case Food.eating.emoji:
      self = .food(.eating)
    case Food.snacks.emoji:
      self = .food(.snacks)
    case Food.others.emoji:
      self = .food(.others)

    case Fruit.apple.emoji:
      self = .fruit(.apple)
    case Fruit.banana.emoji:
      self = .fruit(.banana)
    case Fruit.grapes.emoji:
      self = .fruit(.grapes)
    case Fruit.cherries.emoji:
      self = .fruit(.cherries)
    case Fruit.others.emoji:
      self = .fruit(.others)

    case Drink.beer.emoji:
      self = .drink(.beer)
    case Drink.milk.emoji:
      self = .drink(.milk)
    case Drink.tea.emoji:
      self = .drink(.tea)
    case Drink.wine.emoji:
      self = .drink(.wine)
    case Drink.others.emoji:
      self = .drink(.others)

    case Clothes.shirt.emoji:
      self = .clothes(.shirt)
    case Clothes.pants.emoji:
      self = .clothes(.pants)
    case Clothes.sock.emoji:
      self = .clothes(.sock)
    case Clothes.coat.emoji:
      self = .clothes(.coat)
    case Clothes.skirt.emoji:
      self = .clothes(.skirt)
    case Clothes.others.emoji:
      self = .clothes(.others)

    case Household.goods.emoji:
      self = .household(.goods)
    case Household.travel.emoji:
      self = .household(.travel)
    case Household.love.emoji:
      self = .household(.love)
    case Household.object.emoji:
      self = .household(.object)
    case Household.others.emoji:
      self = .household(.others)

    case Personal.health.emoji:
      self = .personal(.health)
    case Personal.privacy.emoji:
      self = .personal(.privacy)
    case Personal.services.emoji:
      self = .personal(.services)
    case Personal.others.emoji:
      self = .personal(.others)

    case Transportation.taxi.emoji:
      self = .transportation(.taxi)
    case Transportation.car.emoji:
      self = .transportation(.car)
    case Transportation.airplane.emoji:
      self = .transportation(.airplane)
    case Transportation.bus.emoji:
      self = .transportation(.bus)
    case Transportation.metro.emoji:
      self = .transportation(.metro)
    case Transportation.train.emoji:
      self = .transportation(.train)
    case Transportation.boat.emoji:
      self = .transportation(.boat)
    case Transportation.others.emoji:
      self = .transportation(.others)
    case Uncleared.uncleared.emoji:
      self = .uncleared(.uncleared)
    default:
      self = .custom(emoji)
    }
  }
}

extension Catemojis: Hashable {}
