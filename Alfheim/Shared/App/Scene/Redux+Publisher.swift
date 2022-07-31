//
//  Publisher.swift
//  Alfheim
//
//  Created by alex.huo on 2021/11/20.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine

typealias PublisherState<T: Equatable> = T

enum PublisherAction<T> {
  case subscribe
  case receivedValue(T)
  case unsubscribe
}

struct PublisherEnvironment<T> {
  var publisher: AnyPublisher<T, Never>
  var perform: (T) -> Void
  var mainQueue: () -> AnySchedulerOf<DispatchQueue>

  init(
    publisher: AnyPublisher<T, Never>,
    perform: @escaping (T) -> Void = { _ in },
    mainQueue: @escaping () -> AnySchedulerOf<DispatchQueue>
  ) {
    self.publisher = publisher
    self.perform = perform
    self.mainQueue = mainQueue
  }
}

enum Reducers {
  func publisherReducer<T>(
    id: AnyHashable
  ) -> Reducer<PublisherState<T>, PublisherAction<T>, PublisherEnvironment<T>> {
    Reducer { state, action, environment in
      switch action {
      case .subscribe:
        return environment.publisher
          .removeDuplicates()
          .receive(on: environment.mainQueue())
          .eraseToEffect()
          .map(PublisherAction.receivedValue)
          .cancellable(id: id, cancelInFlight: true)

      case .unsubscribe:
        return .cancel(id: id)

      case let .receivedValue(value):
        state = value
        return .fireAndForget {
          environment.perform(value)
        }
      }
    }
  }
}
