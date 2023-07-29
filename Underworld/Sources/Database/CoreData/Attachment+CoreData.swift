//
//  Attachment.swift
//  Database
//
//  Created by alex.huo on 2021/1/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import CoreData

public final class Attachment: NSManagedObject, Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
      return NSFetchRequest<Attachment>(entityName: "Attachment")
  }

  @NSManaged public var id: UUID
  @NSManaged public var thumbnail: NSObject?
  @NSManaged public var url: String?
  // relationship
  @NSManaged public var transaction: Transaction?
}
