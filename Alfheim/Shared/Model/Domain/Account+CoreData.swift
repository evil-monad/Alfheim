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
  @NSManaged var tag: String // Tagit string
  @NSManaged var emoji: String?
  // relationship
  @NSManaged var targets: Set<Transaction>?
  @NSManaged var sources: Set<Transaction>?
  @NSManaged var children: Set<Account>?
  @NSManaged var parent: Account?
}

extension Account {
  enum Strategy {
    case only
    case with
  }

  func transactions(_ strategy: Strategy = .with) -> [Transaction] {
    switch strategy {
    case .only:
      let sources = alne.sources
      let targets = alne.targets
      return sources + targets
    case .with:
      let with = alne.children.flatMap { $0.transactions(.with) }
      let only = transactions(.only)
      return with + only
    }
  }

  var root: Bool {
    parent == nil
  }

  var subroot: Bool {
    parent?.root ?? false
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
  enum Transfer {
    case all // all
    case deposit // increase
    case withdrawal // reduced
  }

  var balance: Double {
    return amount()
  }

  func amount(_ strategy: Strategy = .with, transfer: Transfer = .all) -> Double {
    let deposits = transactions(strategy)
      .filter { (isAncestor(of: $0.target) && $0.amount < 0) || (isAncestor(of: $0.source) && $0.amount >= 0) }
      .map { abs($0.amount) }
      .reduce(0.0, +)

    let withdrawals = transactions(strategy)
      .filter { (isAncestor(of: $0.target) && $0.amount >= 0 ) || (isAncestor(of: $0.source) && $0.amount < 0)  }
      .map { abs($0.amount) }
      .reduce(0.0, +)

    switch transfer {
    case .all:
      return deposits - withdrawals
    case .deposit:
      return deposits
    case .withdrawal:
      return -withdrawals
    }
  }
}

// for ui
extension Account {
  var hasChildren: Bool {
    return !(children?.isEmpty ?? true)
  }

  var fullName: String {
    "\(emoji ?? "")\(name)"
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

extension Account {
  class Snapshot {
    let account: Account?

    var id: UUID
    var name: String
    var introduction: String
    var group: String
    var currency: Int16
    var tag: String
    var emoji: String?

    var targets: Set<Transaction>?
    var sources: Set<Transaction>?
    var children: Set<Account>?
    var parent: Account?

    init(_ account: Account) {
      self.account = account

      self.id = account.id
      self.name = account.name
      self.introduction = account.introduction
      self.group = account.group
      self.currency = account.currency
      self.tag = account.tag
      self.emoji = account.emoji

      self.targets = account.targets
      self.sources = account.sources
      self.children = account.children
      self.parent = account.parent
    }

    init(name: String,
         introduction: String,
         group: String,
         currency: Int16,
         tag: String,
         emoji: String?,
         parent: Account?) {
      self.id = UUID()
      self.name = name
      self.introduction = introduction
      self.group = group
      self.currency = currency
      self.tag = tag
      self.emoji = emoji
      self.parent = parent

      self.targets = nil
      self.sources = nil
      self.children = nil
      self.account = nil
    }
  }
}

extension Alfheim.Account {
  static func object(_ snapshot: Snapshot, context: NSManagedObjectContext) -> Account {
    let object = snapshot.account ?? Account(context: context)
    object.fill(snapshot)
    return object
  }

  func fill(_ snapshot: Snapshot) {
    id = snapshot.id
    name = snapshot.name
    introduction = introduction
    group = snapshot.group
    currency = snapshot.currency
    tag = snapshot.tag
    emoji = snapshot.emoji

    targets = snapshot.targets
    sources = snapshot.sources
    children = snapshot.children
    parent = snapshot.parent
  }
}

func balances(account: Alfheim.Account, transactions: [Alfheim.Transaction]) -> Double {
  let deposits = transactions.filter { (account.isAncestor(of: $0.target) && $0.amount < 0) || (account.isAncestor(of: $0.source) && $0.amount >= 0) }
    .map { abs($0.amount) }
    .reduce(0.0, +)

  let withdrawal = transactions.filter { (account.isAncestor(of: $0.target) && $0.amount >= 0 ) || (account.isAncestor(of: $0.source) && $0.amount < 0)  }
    .map { abs($0.amount) }
    .reduce(0.0, +)

  return deposits - withdrawal
}
