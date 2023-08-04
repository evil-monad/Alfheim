//
//  FetchedResult.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/30.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import CoreData
import Database

public enum FetchedError: Swift.Error {
  case encode(String)
  case decode(String)
  case notFound
}

public protocol FetchedResult: Identifiable {
  associatedtype ResultType: NSFetchRequestResult
  static var identifier: KeyPath<Self, ID> { get }
  static func fetchRequest() -> NSFetchRequest<ResultType>

  @Sendable
  static func map(_ entities: [ResultType]) -> [Self]

  // decode
  init?(from entity: ResultType)
  static func decode(from entity: ResultType) -> Self?
  // encode
  func encode(to context: NSManagedObjectContext) -> ResultType
  func encode(to entity: ResultType)

  static var all: FetchedRequest<Self> { get }
}

public extension FetchedResult {
  static var all: FetchedRequest<Self> {
    .init()
  }

  static func all(sortBy name: String?, ascending: Bool = true) -> FetchedRequest<Self> {
    .init().sort(name, ascending: ascending)
  }
}

extension NSFetchRequestResult {
  func update<T: FetchedResult>(_ item: T) throws where Self == T.ResultType {
    item.encode(to: self)
  }
}
