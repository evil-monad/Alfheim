//
//  FetchedResult.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/30.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import CoreData
import Database

public protocol FetchedResult {
  associatedtype ResultType: NSFetchRequestResult
  static func fetchRequest() -> NSFetchRequest<ResultType>

  static func map(_ entities: [ResultType]) -> [Self]

  // decode
  init?(from entity: ResultType)
  static func decode(from entity: ResultType) -> Self?
  // encode
  func encode(to context: NSManagedObjectContext) -> ResultType
}

public extension FetchedResult {
  static var all: Request<Self> {
    .init()
  }
}
