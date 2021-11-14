//
//  Account+CoreData.swift
//  Domain
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

public protocol AccountProtocol {
  var id: UUID { get }
  var name: String { get set }
  var introduction: String { get set }
  var group: Account.Group { get set }
  var currency: Currency { get set }
  var tag: String { get set }
  var emoji: String? { get set }

  var children: [Account.ID]? { get set }
  var parents: Account.ID? { get set }
}

public struct Account: Equatable, Identifiable {
  public let id: UUID
  public var name: String
  public var introduction: String
  public var group: Group
  public var currency: Currency
  public var tag: String // Tagit string
  public var emoji: String?
  // relationship
  public var targets: [Transaction]
  public var sources: [Transaction]

  public var children: [Account]?
  public var parents: [Account]? // Always <= 1
  public var parent: Account? {
    return parents?.first
  }

  public init(
    id: UUID,
    name: String,
    introduction: String,
    group: Group,
    currency: Currency,
    tag: String,
    emoji: String?,
    targets: [Transaction],
    sources: [Transaction]
  ) {
    self.id = id
    self.name = name
    self.introduction = introduction
    self.group = group
    self.currency = currency
    self.tag = tag
    self.emoji = emoji
    self.targets = targets
    self.sources = sources
  }
}

extension Account {
  public init(
    id: UUID,
    name: String,
    introduction: String,
    group: String,
    currency: Int16,
    tag: String,
    emoji: String?,
    targets: [Transaction]?,
    sources: [Transaction]?
  ) {
    self.id = id
    self.name = name
    self.introduction = introduction
    self.group = Account.Group(rawValue: group)!
    self.currency = Currency(rawValue: currency)!
    self.tag = tag
    self.emoji = emoji
    self.targets = targets ?? []
    self.sources = sources ?? []
  }
}

extension Account: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

public extension Account {
  func descendants() -> [Account.ID] {
    guard let children = children, children.isEmpty else {
      return []
    }

    return [id] + children.flatMap { $0.descendants() }
  }

  func ancestors() -> [Account.ID] {
    guard let parent = parent else {
      return []
    }

    return [id] + parent.ancestors()
  }
}

public extension Account {
  var root: Bool {
    parent == nil
  }

  var subroot: Bool {
    parent?.root ?? false
  }
}

public extension Account {
  init(_ summary: Account.Summary) {
    id = summary.id
    name = summary.name
    introduction = summary.introduction
    group = summary.group
    currency = summary.currency
    tag = summary.tag
    emoji = summary.emoji

    targets = []
    sources = []
    children = nil
    parents = nil
  }

  mutating func applyUpdate(_ summary: Account.Summary) {
    name = summary.name
    introduction = summary.introduction
    group = summary.group
    currency = summary.currency
    tag = summary.tag
    emoji = summary.emoji
  }
}

public extension Account {
  var summary: Account.Summary {
    Account.Summary(
      id: id,
      name: name,
      introduction: introduction,
      group: group,
      currency: currency,
      tag: tag,
      emoji: emoji,
      descendants: descendants(),
      ancestors: ancestors()
    )
  }
}
