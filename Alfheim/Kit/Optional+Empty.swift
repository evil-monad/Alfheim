//
//  String+Empty.swift
//  String+Empty
//
//  Created by alex.huo on 2021/7/25.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
  var orEmpty: String {
    self ?? ""
  }
}

protocol Emptiable {
  var isEmpty: Bool { get }
  var isNotEmpty: Bool { get }
}

extension Emptiable {
  var isNotEmpty: Bool {
      return !isEmpty
  }
}

extension String: Emptiable { }
extension Array: Emptiable { }
extension Dictionary: Emptiable { }
extension Set: Emptiable { }

extension Optional where Wrapped: Emptiable {
  var nilOrEmtpy: Bool {
    switch self {
    case .none:
      return true
    case .some(let value):
      return value.isEmpty
    }
  }
}


final class NonEmpty<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol EmptyCompatible {
    associatedtype BaseType

    var em: NonEmpty<BaseType> { get }
    static var em: NonEmpty<BaseType>.Type { get }
}

extension EmptyCompatible {
    var em: NonEmpty<Self> {
        return NonEmpty(self)
    }

    static var em: NonEmpty<Self>.Type {
        return NonEmpty<Self>.self
    }
}

extension NSObject: EmptyCompatible {}
