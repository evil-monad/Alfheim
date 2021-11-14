//
//  Account+CoreData.swift
//  Database
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class Account: NSManagedObject, Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
      return NSFetchRequest<Account>(entityName: "Account")
  }

  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var introduction: String
  @NSManaged public var group: String
  @NSManaged public var currency: Int16
  @NSManaged public var tag: String // Tagit string
  @NSManaged public var emoji: String?
  // relationship
  @NSManaged public var targets: Set<Transaction>?
  @NSManaged public var sources: Set<Transaction>?
  @NSManaged public var children: Set<Account>?
  @NSManaged public var parent: Account?
}

public extension Account {
  class Snapshot {
    let account: Account?

    public var id: UUID
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

    public init(_ account: Account) {
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

    public init(name: String,
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

public extension Account {
  static func object(_ snapshot: Snapshot, context: NSManagedObjectContext) -> Account {
    let object = snapshot.account ?? Account(context: context)
    object.fill(snapshot)
    return object
  }

  func fill(_ snapshot: Snapshot) {
    id = snapshot.id
    name = snapshot.name
    introduction = snapshot.introduction
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
