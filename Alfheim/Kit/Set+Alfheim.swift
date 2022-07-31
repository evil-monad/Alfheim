//
//  Set+Alfheim.swift
//  Set+Alfheim
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension NSSet {
  func array<T: Hashable>() -> [T] {
    let array = self.compactMap { $0 as? T }
    return array
  }
}

extension Optional where Wrapped == NSSet {
  func array<T: Hashable>(of: T.Type) -> [T] {
    if let set = self as? Set<T> {
      return Array(set)
    }
    return [T]()
  }
}
