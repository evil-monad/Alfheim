//
//  FetchedRequest.swift
//  Alfheim
//
//  Created by alex.huo on 2023/7/30.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public struct FetchedRequest<Result: FetchedResult> {
  var fetchLimit: Int? = nil
  var predicate: NSPredicate? = nil
  var sortDescriptors: [NSSortDescriptor] = []
}

public extension FetchedRequest {
  func limit(_ count: Int) -> Self {
    var req = self
    req.fetchLimit = max(0, count)
    return req
  }

  func filter(_ predicate: NSPredicate) -> Self {
    var req = self
    req.predicate = predicate
    return req
  }

  func `where`(_ predicate: some Predicate) -> Self {
    var req = self
    req.predicate = predicate
    return req
  }

  func sort(_ name: String?, ascending: Bool = true) -> Self {
    let sortDescriptor = NSSortDescriptor(key: name, ascending: ascending)
    var req = self
    req.sortDescriptors.append(sortDescriptor)
    return req
  }

  func sort<Value>(_ keyPath: KeyPath<Result, Value>, ascending: Bool = true) -> Self {
    let sortDescriptor = NSSortDescriptor(keyPath: keyPath, ascending: ascending)
    var req = self
    req.sortDescriptors.append(sortDescriptor)
    return req
  }
}

extension FetchedRequest {
  func makeFetchRequest() -> NSFetchRequest<Result.ResultType> {
    let fetchRequest = Result.fetchRequest()
    fetchRequest.resultType = .managedObjectResultType
    if let fetchLimit {
      fetchRequest.fetchLimit = fetchLimit
    }
    if let predicate {
      fetchRequest.predicate = predicate
    }
    if !sortDescriptors.isEmpty {
      fetchRequest.sortDescriptors = sortDescriptors
    }
    return fetchRequest
  }
}
