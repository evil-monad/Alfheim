//
//  AppReducer.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CasePaths
import ComposableArchitecture
import IdentifiedCollections
import Database
import Domain
import Persistence

public typealias App = RealWorld

@Reducer
public struct RealWorld {

  @Dependency(\.persistent) var persistent

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      enum CancelID: Hashable {
        case observe
        case fetch
      }

      switch action {
      case .loadAll:
        guard !state.hasInitialized else { break }
        state.hasInitialized = true
        return .run { send in
          let stream: AsyncStream<[Domain.Account]> = persistent.observe(
            Domain.Account.all,
            relationships: Domain.Account.relationships,
            transform: Domain.Account.makeTree
          )
          for try await accounts in stream {
            await send(.accountDidChange(accounts))
          }
        }
        .cancellable(id: CancelID.observe)

      case .accountDidChange(let accounts):
        state.home = Home.State(accounts: accounts, selection: state.home.selection)
        return .none

      case .fetchAccounts:
        return .run { send in
          let accounts = try await persistent.fetch(Domain.Account.all.sort("name", ascending: true)) { Domain.Account.map($0) }
          await send(.accountDidFetch(accounts))
        }
        .cancellable(id: CancelID.fetch)

      case .accountDidFetch(let accounts):
        return .send(.accountDidChange(accounts))

      case .cleanup:
        return .run { [state] _ in
          for account in state.home.accounts {
            try await persistent.delete(account)
          }
        }

      case .sidebar:
        state.sidebar = true
        return .none

      case let .home(.select(.some(.account(account)))):
        let overview = Overview.State(account: account)
        if state.sidebar {
          state.detail = .overview(overview)
        } else {
          state.path.append(.overview(overview))
        }
        return .none

      case let .home(.select(.some(.menu(item)))):
        let allTransactions = state.home.accounts.flatMap {
          $0.transactions(.depth)
        }
        let filter = item.filter.transactionFilter
        let transaction = Transaction.State(source: .list(title: item.filter.name, transactions: allTransactions.uniqued(), filter: filter))

        if state.sidebar {
          state.detail = .transation(transaction)
        } else {
          state.path.append(.transation(transaction))
        }
        return .none

      case .transactionDidChange:
        return .none

      default:
        return .none
      }
      return .none
    }
    .forEach(\.path, action: \.path) {
      App.Path()
    }
    .ifLet(\.detail, action: \.detail) {
      App.Detail()
    }

    Scope(state: \.lifecycle, action: \.lifecycle) {
      SceneLifecycle()
    }

    Scope(state: \.main, action: \.main) {
      Main()
    }

    Scope(state: \.home, action: \.home) {
      Home()
    }
  }
}
