//
//  Effect.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Combine

/*
typealias Effect = AnyPublisher

extension Effect {
  static var none: Effect<Output, Failure> {
    Empty(completeImmediately: true).eraseToAnyPublisher()
  }

  func map<T>(_ transform: @escaping (Output) -> T) -> Effect<T, Failure> {
    .init(self.map(transform) as Publishers.Map<Self, T>)
  }
}

extension Effect where Output == Never {
  func forget<T>() -> Effect<T, Failure> {
    func absurd<A>(_ never: Never) -> A {}
    return self.map(absurd)
  }
}

extension Publisher {
  func eraseToEffect() -> Effect<Output, Failure> {
    return eraseToAnyPublisher()
  }
}

class EffectToken {
  var cancellable: AnyCancellable?
  func unseal() { cancellable = nil }
}

extension AnyCancellable {
  func seal(in token: EffectToken) {
    token.cancellable = self
  }
}
*/
