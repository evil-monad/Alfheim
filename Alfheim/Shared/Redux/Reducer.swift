//
//  Reducer.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CasePaths

/*
struct Reducer<State, Action, Environment> {
  let reduce: (inout State, Action, Environment) -> Effect<Action, Never>

  func callAsFunction(
    _ state: inout State,
    _ action: Action,
    _ environment: Environment
  ) -> Effect<Action, Never> {
    reduce(&state, action, environment)
  }

  func lifted<LiftedState, LiftedAction, LiftedEnvironment>(
    state keyPath: WritableKeyPath<LiftedState, State>,
    action liftAction: CasePath<LiftedAction, Action>,
    environment liftEnvironment: @escaping (LiftedEnvironment) -> Environment
  ) -> Reducer<LiftedState, LiftedAction, LiftedEnvironment> {
    Reducer<LiftedState, LiftedAction, LiftedEnvironment> { state, action, environment in
      guard let action = liftAction.extract(from: action) else {
        return .none
      }
      return self.reduce(
        &state[keyPath: keyPath],
        action,
        liftEnvironment(environment)
      )
      .map(liftAction.embed)
      .eraseToEffect()
    }
  }

  func indexed<IndexedState, IndexedAction, IndexedEnvironment>(
    state keyPath: WritableKeyPath<IndexedState, [State]>,
    action indexedAction: CasePath<IndexedAction, (Int, Action)>,
    environment indexedEnvironment: @escaping (IndexedEnvironment) -> Environment
  ) -> Reducer<IndexedState, IndexedAction, IndexedEnvironment> {
    Reducer<IndexedState, IndexedAction, IndexedEnvironment> { state, action, environment in
      guard let (index, indexAction) = indexedAction.extract(from: action) else {
        return .none
      }
      return self.reduce(
        &state[keyPath: keyPath][index],
        indexAction,
        indexedEnvironment(environment)
      )
      .map { indexedAction.embed((index, $0)) }
    }
  }

  func combined(with other: Reducer) -> Reducer {
    Reducer.combine(self, other)
  }

  static func combine(_ reducers: Reducer...) -> Reducer {
    combine(reducers)
  }

  static func combine(_ reducers: [Reducer]) -> Reducer {
    Reducer { state, action, environment in
      let effects = reducers.map { $0.reduce(&state, action, environment) }
      return Publishers.MergeMany(effects).eraseToAnyPublisher()
    }
  }
}
*/
