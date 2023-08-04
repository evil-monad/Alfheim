//
//  Loadable.swift
//  Alfheim
//
//  Created by alex.huo on 2023/8/3.
//  Copyright © 2023 blessingsoft. All rights reserved.
//

import Foundation

public enum Loadable<T> {
  case idle
  case loading
  case success(T)
  case failed
}

extension Loadable {
  public var isLoading: Bool {
    switch self {
    case .loading:
      return true
    default:
      return false
    }
  }

  public var hasInitialized: Bool {
    switch self {
    case .idle:
      return false
    default:
      return true
    }
  }

  public var finished: Bool {
    switch self {
    case .success, .failed:
      return true
    default:
      return false
    }
  }

  public var value: T? {
    if case .success(let value) = self {
      return value
    }
    return nil
  }

  public func map<N>(_ mapped: @escaping (T) -> N) -> Loadable<N> {
    switch self {
    case .idle:
      return .idle
    case .loading:
      return .loading
    case .success(let item):
      return .success(mapped(item))
    case .failed:
      return .failed
    }
  }
}

extension Loadable: Equatable where T: Equatable {}
