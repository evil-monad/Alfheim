//
//  Catemoji.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/1.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

public struct Catemoji {
  public let category: Category
  public let emoji: String

  public init(category: Category, emoji: String) {
    self.category = category
    self.emoji = emoji
  }

  public static let uncleared = Catemoji(category: .uncleared, emoji: Uncleared.uncleared.emoji)
}

extension Catemoji: Hashable {}
