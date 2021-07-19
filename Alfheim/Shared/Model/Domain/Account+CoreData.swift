//
//  Account+CoreData.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

final class Account: NSManagedObject, Identifiable {
  class func fetchRequest() -> NSFetchRequest<Account> {
      return NSFetchRequest<Account>(entityName: "Account")
  }

  @NSManaged var id: UUID
  @NSManaged var name: String
  @NSManaged var introduction: String
  @NSManaged var group: String
  @NSManaged var currency: Int16
  @NSManaged var tag: String?
  @NSManaged var emoji: String?
  // relationship
  @NSManaged var targets: NSSet?
  @NSManaged var sources: NSSet?
  @NSManaged var children: Set<Account>?
  @NSManaged var parent: Account?
}

extension Account {
  enum TransactionStrategy {
    case only
    case with
  }

  func transactions(_ strategy: TransactionStrategy = .with) -> [Transaction] {
    switch strategy {
    case .only:
      let sources = sources?.allObjects as? [Transaction] ?? []
      let targets = targets?.allObjects as? [Transaction] ?? []
      return sources + targets
    case .with:
      let with = children?.flatMap { $0.transactions(.with) } ?? []
      let only = transactions(.only)
      return with + only
    }
  }

  var root: Bool {
    return parent == nil
  }

  var optinalChildren: [Account]? {
    guard let children = children, !children.isEmpty else {
      return nil
    }
    return Array(children)
  }
}

// deposit & withdrawal
extension Account {
  var amount: Double {
    let deposits = transactions().filter { isAncestor(of: $0.target) }
      .map { abs($0.amount) }
      .reduce(0.0, +)

    let withdrawal = transactions().filter { isAncestor(of: $0.source) }
      .map { abs($0.amount) }
      .reduce(0.0, +)

    return deposits - withdrawal
  }
}

// for ui
extension Account {
  var hasChildren: Bool {
    return !(children?.isEmpty ?? true)
  }
}

extension Account {
  func hasCommonDescent(with other: Account) -> Bool {
    if self == other {
      return true
    }

    guard let ancestor = parent else {
      return false
    }

    return ancestor.hasCommonDescent(with: other)
  }

  func isDescendant(of other: Account) -> Bool {
    if self == other {
      return true
    }

    guard let parcent = parent else {
      return false
    }

    return parcent.isDescendant(of: other)
  }

  func isAncestor(of other: Account?) -> Bool {
    guard let other = other else {
      return false
    }

    return other.isDescendant(of: self)
  }

  private func lca(p: Account, q: Account) -> Account? {
    return nil
  }
}

extension Account {
  // Just like Equatable `==` method
  static func duplicated(lhs: Account, rhs: Account) -> Bool {
    guard lhs.id == rhs.id,
      lhs.name == rhs.name,
      lhs.introduction == rhs.introduction,
      lhs.group == rhs.group,
      lhs.currency == rhs.currency,
      lhs.tag == rhs.tag,
      lhs.emoji == rhs.emoji,
      lhs.targets == rhs.targets,
      lhs.sources == rhs.sources
    else {
      return false
    }
    return true
  }
}

extension NSSet {
  func array<T: Hashable>() -> [T] {
    let array = self.compactMap { $0 as? T }
    return array
  }
}

extension Optional where Wrapped == NSSet {
  func array<T: Hashable>(of: T.Type) -> [T] {
    if let set = self as? Set<T> {
      return Array(set)
    }
    return [T]()
  }
}
