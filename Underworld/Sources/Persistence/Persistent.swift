//
//  Persistent.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData
import Dependencies

/// Persistent client
public protocol Persistent {
  var context: NSManagedObjectContext? { get }
  func reload()
  func save()
}

enum PersistencesKey: DependencyKey {
  static let liveValue: Persistent = CloudPersistent()
  static let previewValue: Persistent = PreviewPersistent()
}

extension DependencyValues {
  public var persistent: Persistent {
    get { self[PersistencesKey.self] }
    set { self[PersistencesKey.self] = newValue }
  }
}
