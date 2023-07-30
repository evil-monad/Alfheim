//
//  Account.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Kit
import Alne
import Database
import Domain
import CoreData

extension Domain.Account: FetchedResult {
  public static func fetchRequest() -> NSFetchRequest<Database.Account> {
    Database.Account.fetchRequest()
  }
}

// MARK: decode
extension Domain.Account {
  public init?(from entity: Database.Account) {
    let targets = entity.targets?.compactMap(Domain.Transaction.init)
    let sources = entity.sources?.compactMap(Domain.Transaction.init)
    self.init(
      id: entity.id,
      name: entity.name,
      introduction: entity.introduction,
      group: entity.group,
      currency: entity.currency,
      tag: entity.tag,
      emoji: entity.emoji,
      targets: targets,
      sources: sources
    )
  }

  public static func decode(from entity: Database.Account) -> Domain.Account? {
    self.init(from: entity)
  }

  public static func map(_ entities: [Database.Account]) -> [Domain.Account] {
    func makeAccounts(accounts: Set<Database.Account>?, parent: Domain.Account?) -> [Domain.Account] {
      guard let accounts = accounts else {
        return []
      }

      return Array(accounts.sorted(by: { $0.name < $1.name })).flatMap { ele -> [Domain.Account] in
        guard var model = Domain.Account(from: ele) else {
          return []
        }
        model.parents = parent.map { [$0] }
        let children = makeAccounts(accounts: ele.children, parent: model)
        model.children = children.optional
        let ret = [model] + children
        return ret
      }
    }

    return makeAccounts(accounts: Set(entities.filter { $0.parent == nil }), parent: nil)
  }

  public func encode(to context: NSManagedObjectContext) -> Database.Account {
    let object = Database.Account(context: context)
    object.fill(self)
    return object
  }
}

// MARK: encode
public extension Database.Account {
  func fill(_ model: Domain.Account) {
    id = model.id
    name = model.name
    introduction = model.introduction
    group = model.group.rawValue
    currency = model.currency.rawValue
    tag = model.tag
    emoji = model.emoji
  }

  func fill(targets: [Database.Transaction]) {
    self.targets = Set(targets)
  }

  func fill(sources: [Database.Transaction]) {
    self.targets = Set(sources)
  }

  func fill(children: [Database.Account]) {
    self.children = Set(children)
  }

  func fill(parent: Database.Account) {
    self.parent = parent
  }
}

public extension Domain.Account {
  enum Strategy {
    case only
    case with
  }

  func transactions(_ strategy: Strategy = .with) -> [Domain.Transaction] {
    switch strategy {
    case .only:
      return sources + targets
    case .with:
      if let children = children {
        let with: [Domain.Transaction] = children.flatMap { $0.transactions(.with) }
        let only = transactions(.only)
        return with + only
      } else {
        return transactions(.only)
      }
    }
  }
}

public extension Domain.Account {
  func hasCommonDescent(with other: Domain.Account) -> Bool {
    if self == other {
      return true
    }

    guard let ancestor = parent else {
      return false
    }

    return ancestor.hasCommonDescent(with: other)
  }

  func isDescendant(of other: Domain.Account) -> Bool {
    if self == other {
      return true
    }

    guard let parcent = parent else {
      return false
    }

    return parcent.isDescendant(of: other)
  }

  func isAncestor(of other: Domain.Account?) -> Bool {
    guard let other = other else {
      return false
    }

    return other.isDescendant(of: self)
  }

  private func lca(p: Domain.Account, q: Domain.Account) -> Domain.Account? {
    return nil
  }
}

// deposit & withdrawal
public extension Domain.Account {
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
      .filter { (summary.isAncestor(of: $0.target) && $0.amount < 0) || (summary.isAncestor(of: $0.source) && $0.amount >= 0) }
      .map { abs($0.amount) }
      .reduce(0.0, +)

    let withdrawals = transactions(strategy)
      .filter { (summary.isAncestor(of: $0.target) && $0.amount >= 0 ) || (summary.isAncestor(of: $0.source) && $0.amount < 0)  }
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

public func balances(account: Domain.Account, transactions: [Domain.Transaction]) -> Double {
  let deposits = transactions.filter { (account.summary.isAncestor(of: $0.target) && $0.amount < 0) || (account.summary.isAncestor(of: $0.source) && $0.amount >= 0) }
    .map { abs($0.amount) }
    .reduce(0.0, +)

  let withdrawal = transactions.filter { (account.summary.isAncestor(of: $0.target) && $0.amount >= 0 ) || (account.summary.isAncestor(of: $0.source) && $0.amount < 0)  }
    .map { abs($0.amount) }
    .reduce(0.0, +)

  return deposits - withdrawal
}

// for ui
public extension Domain.Account {
  var hasChildren: Bool {
    return !(children?.isEmpty ?? true)
  }

  var fullName: String {
    "\(emoji ?? "")\(name)"
  }

  var tagit: Tagit {
    Tagit(stringLiteral: tag)
  }

  var canDelete: Bool {
    children.nilOrEmtpy && transactions(.only).isEmpty
  }
}


//#if DEBUG
public extension Domain.Account {
  static func mock() -> Domain.Account {
    let source = Domain.Account(
      id: UUID(),
      name: "Checking",
      introduction: "Assets",
      group: .assets,
      currency: .cny,
      tag: "Tag",
      emoji: "🍉",
      targets: [],
      sources: []
    )
    return source
  }
}
//#endif
