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

  func observe<T>(_ request: FetchedRequest<T>, relationships: [Relationship], transform: @Sendable @escaping ([T.ResultType]) -> [T]) -> AsyncStream<[T]>
  func asyncObserve<T>(_ request: FetchedRequest<T>) async -> AsyncStream<[T]>

  func fetch<T>(_ request: FetchedRequest<T>) async throws -> [T]
  func fetch<T>(_ request: FetchedRequest<T>, transform: @escaping ([T.ResultType]) -> [T]) async throws -> [T]

  @discardableResult
  func update<T: FetchedResult>(_ item: T) async throws -> Bool
  @discardableResult
  func update<T: FetchedResult, V>(_ item: T, keyPath: WritableKeyPath<T.ResultType, V>, value: V) async throws -> Bool
  @discardableResult
  func update<T: FetchedResult, V>(_ item: T.ID, keyPath: WritableKeyPath<T.ResultType, V>, value: V) async throws -> T
  @discardableResult
  func update<T: FetchedResult, R: FetchedResult>(_ item: T, relationships: [(keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, value: R?)]) async throws -> Bool

  func insert<T: FetchedResult>(_ item: T) async throws
  func insert<T: FetchedResult, R: FetchedResult>(_ item: T, relationships: [(keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, value: R?)]) async throws

  func delete<T: FetchedResult>(_ item: T) async throws

  @discardableResult
  func sync<T: FetchedResult, R: FetchedResult>(item: T, keyPath: WritableKeyPath<T.ResultType, R.ResultType>, to relation: R) async throws -> Bool
  @discardableResult
  func sync<T: FetchedResult, R: FetchedResult>(item: T, keyPath: WritableKeyPath<T.ResultType, R.ResultType?>, to relation: R?) async throws -> Bool

  func reload()
  func save()
}

public extension Persistent {
  func observe<T>(_ request: FetchedRequest<T>, relationships: [Relationship] = [], transform: @Sendable @escaping ([T.ResultType]) -> [T] = T.map) -> AsyncStream<[T]> {
    observe(request, relationships: relationships, transform: transform)
  }
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
