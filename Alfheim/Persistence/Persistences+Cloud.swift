//
//  Persistences+Cloud.swift
//  Persistences+Cloud
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

extension Persistences {
  struct Cloud {
    let store: CloudKit
    let context: NSManagedObjectContext?

    init() {
      store = CloudKit()
      context = store.persistentContainer?.viewContext
    }
  }
}
