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

typealias App = RealWorld

struct RealWorld: ReducerProtocol {

  @Dependency(\.context) var context
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      struct CancelId: Hashable {}

      switch action {
      case .loadAll:
        return Effect
          .merge(
            Account.Effects.load(context: context),
            Transaction.Effects.fetch(context: context)
          )

      case .accountDidChange(let accounts):
        state.home = Home.State(accounts: accounts, selection: state.home.selection)
        state.overviews = IdentifiedArray(uniqueElements: accounts.map { Overview.State(account: $0) })
        return .none

      case .fetchAccounts:
        return Account.Effects.fetchAll(context: context, on: .main)
          .cancellable(id: CancelId(), cancelInFlight: true)

      case .accountDidFetch(let accounts):
        return Effect(value: .accountDidChange(accounts))

      case .cleanup:
        return Account.Effects.delete(accounts: state.accounts, context: context)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()

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
        return Account.Effects.delete(accounts: [account], context: context)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()

      case .selectMenu(let item):
        if let item = item, let filter = QuickFilter(rawValue: item.id) {
          let allTransactions = state.home.accounts.flatMap {
            $0.transactions(.only)
          }
          let uniqueTransactions = Domain.Transaction.uniqued(allTransactions)
          let transaction = Transaction.State(source: .list(title: filter.name, transactions: filter.filteredTransactions(uniqueTransactions)))
          state.home.selection = item
          state.path.append(.transation(transaction))
        } else {
          state.home.selection = nil
          return .cancel(id: CancelId())
        }
        return .none

      case .transactionDidChange(let transactions):
        // TODO: find changed transaction, and update account
        if let selection = state.home.selection {
          return Effect(value: .selectMenu(selection))
        }
        return .none

      default:
        return .none
      }
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
