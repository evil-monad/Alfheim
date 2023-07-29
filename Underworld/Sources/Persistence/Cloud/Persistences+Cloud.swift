//
//  Persistences+Cloud.swift
//  Persistences+Cloud
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public extension Persistences {
  struct Cloud {
    let store: CloudStore
    private(set) var context: NSManagedObjectContext?

    init() {
      store = CloudStore()
      context = store.persistentContainer?.viewContext
    }

    func save() {
      store.saveContext()
    }

    mutating func reloadContainer() {
      store.reloadContainer()
      context = store.persistentContainer?.viewContext
    }
  }
}
