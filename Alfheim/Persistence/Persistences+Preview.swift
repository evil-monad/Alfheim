//
//  Persistences+Preview.swift
//  Alfheim
//
//  Created by alex.huo on 2021/7/24.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

extension Persistences {
  struct Preview {
    let store: MemoryStore
    let context: NSManagedObjectContext

    init() {
      store = MemoryStore()
      context = store.persistentContainer.viewContext

      // preview memory data
    }

    func save() {
      store.saveContext()
    }
  }
}
