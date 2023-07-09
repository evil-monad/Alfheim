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
  struct State: Equatable {
    var overviews: IdentifiedArrayOf<Overview.State> = []
    //var editor = Editor()

    var home = Home.State()

    var settings = Settings.State()

    var isAddingAccount: Bool = false
    var editAccount = EditAccount.State()
    var isAccountSelected: Bool = false

    var path = StackState<Path.State>()
  }

  struct Path: ReducerProtocol {
    enum State: Equatable {
      case overview(Overview.State)
      case transation(Transaction.State)
    }

    enum Action: Equatable {
      case overview(Overview.Action)
      case transation(Transaction.Action)
    }

    var body: some ReducerProtocol<State, Action> {
      Scope(state: /State.overview, action: /Action.overview) {
        Overview()
      }
      Scope(state: /State.transation, action: /Action.transation) {
        Transaction()
      }
    }
  }
}

extension RealWorld.State {
  var accounts: [Domain.Account] {
    overviews.map { $0.account }
  }

  var rootAccounts: [Domain.Account] {
    accounts.filter { $0.root }
  }
}
