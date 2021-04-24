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
  @NSManaged var children: NSSet?
  @NSManaged var parent: Account?
}

extension Account {
  var transactions: [Transaction] {
    if let s = sources?.allObjects as? [Transaction], let t = targets?.allObjects as? [Transaction] {
      return s + t
    } else {
      return []
    }
  }

  var root: Bool {
    return parent == nil
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
