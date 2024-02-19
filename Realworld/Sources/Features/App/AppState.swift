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
  @ObservableState
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

  @Reducer(state: .equatable)
  public enum Path {
    case overview(Overview)
    case transation(Transaction)
  }

  @Reducer
  public struct Detail {
    @ObservableState
    public enum State: Equatable {
      case overview(Overview.State)
      case transation(Transaction.State)
    }

    public enum Action: Equatable {
      case overview(Overview.Action)
      case transation(Transaction.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: \.overview, action: \.overview) {
        Overview()
      }
      Scope(state: \.transation, action: \.transation) {
        Transaction()
      }
    }
  }
}
