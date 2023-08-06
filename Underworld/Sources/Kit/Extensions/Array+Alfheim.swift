//
//  Array+Alfheim.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension Array {
  /// RangeReplaceableCollection.remove(atOffsets offsets: IndexSet)
  public func elements(atOffsets offsets: IndexSet) -> [Element] {
    enumerated()
      .filter { offsets.contains($0.offset) }
      .map { $0.element }
  }
}

extension Array where Element: Equatable {
  /// if elements hadn't be sorted, the result maybe not unique
  public func grouped() -> [[Element]] {
    return _grouped(by: ==)
  }
}

public extension Array {
  // must be sorted first
  fileprivate func _grouped(by predicate: (Element, Element) -> Bool) -> [[Element]] {
    var results = [Array<Element>]()

    forEach {
      if var lastGroup = results.last, let element = lastGroup.last, predicate(element, $0) {
        lastGroup.append($0)
        results.removeLast()
        results.append(lastGroup)
      } else {
        results.append([$0])
      }
    }
    return results
  }
}

extension Array where Element: Comparable {
  public func grouped(by predicate: (Element, Element) -> Bool) -> [[Element]] {
    sorted(by: predicate)._grouped(by: predicate)
  }
}

public extension Array {
  func grouped<G: Hashable>(by closure: (Element) -> G) -> [G: [Element]] {
    var results = [G: Array<Element>]()

    forEach {
      let key = closure($0)

      if var array = results[key] {
        array.append($0)
        results[key] = array
      } else {
        results[key] = [$0]
      }
    }

    return results
  }
}

public extension Array {
  var optional: Self? {
    if self.isEmpty {
      return nil
    } else {
      return self
    }
  }
}
