//
//  Emoji+CoreData.swift
//  Database
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class Emoji: NSManagedObject, Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Emoji> {
      return NSFetchRequest<Emoji>(entityName: "Emoji")
  }

  @NSManaged public var category: String
  @NSManaged public var text: String
}
