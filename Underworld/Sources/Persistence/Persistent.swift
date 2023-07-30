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
import Database

/// Persistent client
public protocol Persistent {
  var context: NSManagedObjectContext { get }
  func fetch<T>(_ request: Request<T>) async throws -> [T]
  func observe<T>(_ request: Request<T>) -> AsyncStream<[T]>
  func asyncObserve<T>(_ request: Request<T>) async -> AsyncStream<[T]>

//  func update<T>(_ request: Request<T>) async throws -> Bool
  func insert<T: FetchedResult>(_ item: T) async throws

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
