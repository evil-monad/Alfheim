//
//  Main+State.swift
//  Alfheim
//
//  Created by alex.huo on 2021/12/18.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import ComposableArchitecture

struct Main: Reducer {

  struct State: Equatable {
    @PresentationState var destination: Destination.State?
  }

  enum Action: Equatable {
    case newAccount
    case settings
    case destination(PresentationAction<Destination.Action>)
    case dismiss
  }

  struct Destination: Reducer {
    enum State: Equatable {
      case newAccount(EditAccount.State)
      case settings(Settings.State)
    }
    enum Action: Equatable, Sendable {
      case newAccount(EditAccount.Action)
      case settings(Settings.Action)
    }

    var body: some ReducerOf<Self> {
      EmptyReducer()
      .ifCaseLet(/State.newAccount, action: /Action.newAccount) {
        EditAccount()
      }
      .ifCaseLet(/State.settings, action: /Action.settings) {
        Settings()
      }
    }
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .newAccount:
        state.destination = .newAccount(EditAccount.State())
        return .none

      case .settings:
        state.destination = .settings(Settings.State())
        return .none

      case .dismiss:
        state.destination = nil
        return .none

      case .destination(.presented(.newAccount(.delegate))):
        state.destination = nil
        return .none

      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
  }
}
