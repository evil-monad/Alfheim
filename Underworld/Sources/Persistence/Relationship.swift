//
//  Relationship.swift
//  Alfheim
//
//  Created by alex.huo on 2023/8/5.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import Foundation
import CoreData
import Domain

public protocol Predicate<Root>: NSPredicate {
    associatedtype Root: FetchedResult
}

public final class ComparisonPredicate<Root: FetchedResult>: NSComparisonPredicate, Predicate {}

extension ComparisonPredicate {
  convenience init(
    _ keyPath: KeyPath<Root, Root.ID>,
    _ op: NSComparisonPredicate.Operator,
    _ id: Root.ID
  ) {
    let lhs = NSExpression(forKeyPath: "id") // NSExpression(forKeyPath: keyPath)
    let rhs = NSExpression(forConstantValue: id)
    self.init(leftExpression: lhs, rightExpression: rhs, modifier: .direct, type: op)
  }
}

public func == <Root> (keyPath: KeyPath<Root, Root.ID>, id: Root.ID) -> ComparisonPredicate<Root> {
  ComparisonPredicate(keyPath, .equalTo, id)
}


public protocol RelationshipValue {
}

extension NSManagedObject: RelationshipValue {
}

public struct Relationship {
  public let name: String
  public let keyPath: String // KeyPath<K, V>
  public let isChildren: Bool // children node
  public let isToMany: Bool

  public init<K, V>(name: String, keyPath: KeyPath<K, V>, isChildren: Bool, isToMany: Bool) {
    self.name = name
    self.keyPath = name // NSExpression(forKeyPath: keyPath).keyPath
    self.isChildren = isChildren
    self.isToMany = true
  }
}

public extension Domain.Account {
  static var relationships = [
    Relationship(name: "targets", keyPath: \Self.targets, isChildren: false, isToMany: true),
    Relationship(name: "sources", keyPath: \Self.sources, isChildren: false, isToMany: true),
    Relationship(name: "children", keyPath: \Self.children, isChildren: true, isToMany: true),
  ]
}

public extension Domain.Transaction {
  static var relationships = [
    Relationship(name: "target", keyPath: \Self.target, isChildren: false, isToMany: false),
    Relationship(name: "target", keyPath: \Self.source, isChildren: false, isToMany: false),
  ]
}
