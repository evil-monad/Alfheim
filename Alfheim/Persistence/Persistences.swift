//
//  Persistences.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/8.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

enum Persistences {
  enum Usage {
    case main // CloudKit
    case preview // Memory
    case extensions
  }
}

extension NSManagedObjectContext {
  func registeredObjects(with predicate: NSPredicate) -> Set<NSManagedObject> {
    registeredObjects.filter { predicate.evaluate(with: $0) }
  }

  func registeredObjects<T>(_ type: T.Type, with predicate: NSPredicate) -> [T] {
    (registeredObjects.compactMap { $0 as? T }).filter { predicate.evaluate(with: $0) }
  }
}

