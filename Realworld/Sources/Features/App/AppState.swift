//
//  AppEnvironment.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture
import Domain

extension RealWorld {
  public struct State: Equatable {
    var hasInitialized: Bool = false

    var lifecycle = SceneLifecycle.State()
    var main = Main.State()
    var home = Home.State()

    var sidebar: Bool = false
    // for iPadOS
    var detail: Detail.State?
    // for iOS
    var path = StackState<Path.State>()

    public init() {}
  }

  public struct Path: Reducer {
    public enum State: Equatable {
      case overview(Overview.State)
      case transation(Transaction.State)
    }

    public enum Action: Equatable {
      case overview(Overview.Action)
      case transation(Transaction.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.overview, action: /Action.overview) {
        Overview()
      }
      Scope(state: /State.transation, action: /Action.transation) {
        Transaction()
      }
    }
  }

  public struct Detail: Reducer {
    public enum State: Equatable {
      case overview(Overview.State)
      case transation(Transaction.State)
    }

    public enum Action: Equatable {
      case overview(Overview.Action)
      case transation(Transaction.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.overview, action: /Action.overview) {
        Overview()
      }
      Scope(state: /State.transation, action: /Action.transation) {
        Transaction()
      }
    }
  }
}
