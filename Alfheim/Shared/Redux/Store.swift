//
//  Store.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/3.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

/*
final class Store<State, Action>: ObservableObject {
  @Published private(set) var state: State

  private let reducer: (inout State, Action) -> Effect<Action, Never>
  private let queue: DispatchQueue
  private var effectCancellables: [UUID: AnyCancellable] = [:]
  /// store parent cancellable
  private var cancellable: AnyCancellable?

  convenience init<Environment>(
    initialState: State,
    reducer: Reducer<State, Action, Environment>,
    environment: Environment,
    queue: DispatchQueue = .init(label: "")
  ) {
    self.init(
      initialState: initialState,
      reducer: { reducer.reduce(&$0, $1, environment) },
      queue: queue)
  }

  private init(
    initialState: State,
    reducer: @escaping (inout State, Action) -> Effect<Action, Never>,
    queue: DispatchQueue = .init(label: "")
  ) {
    self.state = initialState
    self.reducer = reducer
    self.queue = queue
  }

  func derived<ScopedState>(
    state scopedState: @escaping (State) -> ScopedState
  ) -> Store<ScopedState, Action> {
    self.derived(state: scopedState, action: { $0 })
  }

  func derived<ScopedState, ScopedAction>(
    state scopedState: @escaping (State) -> ScopedState,
    action embedAction: @escaping (ScopedAction) -> Action
  ) -> Store<ScopedState, ScopedAction> {
    let store = Store<ScopedState, ScopedAction>(
      initialState: scopedState(self.state),
      reducer: { state, action in
        self.dispatch(embedAction(action))
        // state = scopedState(self.state)
        return Effect.none
      }
    )
    if #available(iOS 14.0, *) {
      $state.map(scopedState)
        .assign(to: &store.$state)
    } else {
      store.cancellable = $state.map(scopedState)
        .sink { [weak store] in
        store?.state = $0
      }
    }

    return store
  }

  func dispatch(_ action: Action) {
    print("[ACTION]: \(action)")
    let effect = reducer(&state, action)

    let token = EffectToken()
    effect
      .subscribe(on: queue)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { _ in
          token.unseal()
        },
        receiveValue: { [weak self] in
          self?.dispatch($0)
        }
      )
      .seal(in: token)

    /*
    var completed = false
    let uuid = UUID()
    let cancellable = effect
      .subscribe(on: queue)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] _ in
          completed = true
          self?.effectCancellables[uuid] = nil
        },
        receiveValue: { [weak self] in
          self?.dispatch($0)
        }
      )

    if !completed {
      effectCancellables[uuid] = cancellable
    }
     */
  }
}

extension Store {
  func binding<Value>(
    for keyPath: KeyPath<State, Value>,
    to action: @escaping (Value) -> Action
  ) -> Binding<Value> {
    Binding<Value>(
      get: {
        let a = self.state[keyPath: keyPath]
        return a

      },
      set: {
        self.dispatch(action($0))
      }
    )
  }
}
*/
