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

typealias App = RealWorld

struct RealWorld: Reducer {

  @Dependency(\.persistent) var persistent
  
  var body: some ReducerOf<Self> {
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
          let stream: AsyncStream<[Domain.Account]> = persistent.observe(Domain.Account.all, transform: Domain.Account.makeTree)
          for try await accounts in stream {
            await send(.accountDidChange(accounts))
          }
        }
        .cancellable(id: CancelID.observe)

      case .accountDidChange(let accounts):
        state.home = Home.State(accounts: accounts, selection: state.home.selection)
        state.overviews = IdentifiedArray(uniqueElements: accounts.map { Overview.State(account: $0) })
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
          for account in state.accounts {
            try await persistent.delete(account)
          }
        }

      case .addAccount(let presenting):
        state.editAccount.reset(.new)
        state.isAddingAccount = presenting
        return .none

      case let .account(presenting, account):
        if let account = account {
          state.editAccount.reset(.edit(account))
        } else {
          state.editAccount.reset(.new)
        }
        state.isAccountSelected = presenting
        return .none

      case .deleteAccount(let account):
        if !account.canDelete {
          return .none
        }
        return .run { _ in
          try await persistent.delete(account)
        }

      case .selectMenu(let item):
        if let item = item {
          let allTransactions = state.home.accounts.flatMap {
            $0.transactions(.current)
          }
          let filter = item.filter.transactionFilter
          let transaction = Transaction.State(source: .list(title: item.filter.name, transactions: allTransactions.uniqued(), filter: filter))
          state.home.selection = item
          state.path.append(.transation(transaction))
        } else {
          state.home.selection = nil
          return .concatenate(.cancel(id: CancelID.fetch))
        }
        return .none

      case .transactionDidChange(let transactions):
        // TODO: find changed transaction, and update account
        if let selection = state.home.selection {
          return .send(.selectMenu(selection))
        }
        return .none

      default:
        return .none
      }
      return .none
    }
    .forEach(\.path, action: /Action.path) {
      App.Path()
    }

    Scope(state: \.editAccount, action: /App.Action.editAccount) {
      EditAccount()
    }

    Scope(state: \.settings, action: /App.Action.settings) {
      Settings()
    }

    Reduce { state, action in
      switch action {
      case .lifecycle(.willConnect):
        // TODO: load all data
        return .none
      case .lifecycle(.willEnterForeground):
        // TODO: Sync iCloud, Subscribe
        return .none
      case .lifecycle(.didEnterBackground):
        // TODO: Unsubscribe
        return .none
      case .lifecycle:
        return .none
      default:
        return .none
      }
    }
  }
}
