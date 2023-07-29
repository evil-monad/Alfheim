//
//  Persistences+Preview.swift
//  Alfheim
//
//  Created by alex.huo on 2021/7/24.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class PreviewPersistent: Persistent {
  let store: MemoryStore
  public let context: NSManagedObjectContext?

  public init() {
    store = MemoryStore()
    context = store.persistentContainer.viewContext

    // preview memory data
  }

  public func save() {
    store.saveContext()
  }

  public func reload() {

  }
}
