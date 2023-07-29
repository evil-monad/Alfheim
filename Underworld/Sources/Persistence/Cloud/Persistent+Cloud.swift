//
//  Persistences+Cloud.swift
//  Persistences+Cloud
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class CloudPersistent: Persistent {
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

  public func reload() {
    store.reloadContainer()
    context = store.persistentContainer?.viewContext
  }
}
