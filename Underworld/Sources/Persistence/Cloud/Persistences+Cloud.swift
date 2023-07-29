//
//  Persistences+Cloud.swift
//  Persistences+Cloud
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public struct Cloud {
  let store: CloudStore
  public private(set) var context: NSManagedObjectContext?

  public init() {
    store = CloudStore()
    store.reloadContainer()
    context = store.persistentContainer?.viewContext
  }

  public func save() {
    store.saveContext()
  }

  public mutating func reloadContainer() {
    store.reloadContainer()
    context = store.persistentContainer?.viewContext
  }
}
