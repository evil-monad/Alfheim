//
//  Account+Summary.swift
//  Alfheim
//
//  Created by alex.huo on 2021/11/14.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Database
import Domain

extension Domain.Account.Summary {
  init(_ entity: Database.Account) {
    self.init(
      id: entity.id,
      name: entity.name,
      introduction: entity.introduction,
      group: entity.group,
      currency: entity.currency,
      tag: entity.tag,
      emoji: entity.emoji,
      descendants: entity.descendants(),
      ancestors: entity.ancestors()
    )
  }
}

extension Domain.Account.Summary {
  var fullName: String {
    "\(emoji ?? "")\(name)"
  }

  var tagit: Tagit {
    Tagit(stringLiteral: tag)
  }
}

extension Domain.Account.Summary {
  func hasCommonDescent(with other: Domain.Account.Summary) -> Bool {
    if self == other {
      return true
    }

    guard let lhs = ancestors else {
      return false
    }

    return !Set(lhs).intersection(Set([other.id])).isEmpty
  }

  func isDescendant(of other: Domain.Account.Summary) -> Bool {
    if self == other {
      return true
    }

    guard let descendants = other.descendants else {
      return false
    }

    return descendants.contains(id)
  }

  func isAncestor(of other: Domain.Account.Summary?) -> Bool {
    guard let other = other else {
      return false
    }

    guard let ancestors = other.ancestors else {
      return false
    }

    return ancestors.contains(id)
  }

  private func lca(p: Domain.Account, q: Domain.Account) -> Domain.Account? {
    return nil
  }
}
