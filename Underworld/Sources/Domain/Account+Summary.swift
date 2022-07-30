//
//  AccountSummary.swift
//  Domain
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

public extension Account {
  struct Summary: Equatable, Identifiable {
    public let id: UUID
    public var name: String
    public var introduction: String
    public var group: Account.Group
    public var currency: Currency
    public var tag: String // Tagit string
    public var emoji: String?

    public var descendants: [Account.ID]?
    public var ancestors: [Account.ID]?

    public init(
      id: UUID,
      name: String,
      introduction: String,
      group: Group,
      currency: Currency,
      tag: String,
      emoji: String?,
      descendants: [Account.ID]?,
      ancestors: [Account.ID]?
    ) {
      self.id = id
      self.name = name
      self.introduction = introduction
      self.group = group
      self.currency = currency
      self.tag = tag
      self.emoji = emoji
      self.descendants = descendants
      self.ancestors = ancestors
    }
  }
}

extension Account.Summary {
  public init(
    id: UUID,
    name: String,
    introduction: String,
    group: String,
    currency: Int16,
    tag: String,
    emoji: String?,
    descendants: [Account.ID]?,
    ancestors: [Account.ID]?
  ) {
    self.id = id
    self.name = name
    self.introduction = introduction
    self.group = Account.Group(rawValue: group)!
    self.currency = Currency(rawValue: currency)!
    self.tag = tag
    self.emoji = emoji
    self.descendants = descendants
    self.ancestors = ancestors
  }
}
