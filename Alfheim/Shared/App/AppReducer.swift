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
        state.sidebar = App.State.Sidebar(accounts: accounts, selectionMenu: state.sidebar.selection?.id)
        state.overviews = IdentifiedArray(uniqueElements: accounts.map { Overview.State(account: $0) })
        if let id = state.selection?.id, let overview = state.overviews[id: id] {
          state.selection = Identified(overview, id: id)
        }
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
        state.accountEditor.reset(.new)
        state.isAddingAccount = presenting
        return .none
      case let .editAccount(presenting, account):
        if let account = account {
          state.accountEditor.reset(.edit(account))
        } else {
          state.accountEditor.reset(.new)
        }
        state.isEditingAccount = presenting
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
      case .selectMenu(selection: let item):
        if let id = item, let filter = App.State.QuickFilter(rawValue: id) {
          let allTransactions = state.sidebar.accounts.flatMap {
            $0.transactions(.only)
          }
          let uniqueTransactions = Domain.Transaction.uniqued(allTransactions)
          let transaction = Transaction.State(source: .list(title: filter.name, transactions: filter.filteredTransactions(uniqueTransactions)))
          state.sidebar.selection = Identified(transaction, id: id)
        } else {
          state.sidebar.selection = nil
          return .cancel(id: CancelId())
        }
        return .none

      case let .selectAccount(id: id):
        if let id = id, let overview = state.overviews[id: id] {
          state.selection = Identified(overview, id: id)
        } else {
          state.selection = nil
        }
        return .none
      case .transactionDidChange(let transactions):
        // TODO: find changed transaction, and update account
        if let selection = state.sidebar.selection {
          return Effect(value: .selectMenu(selection: selection.id))
        }
        if let selection = state.selection, let overview = selection.value {
          state.overviews[id: selection.id] = Overview.State(account: overview.account)
        }
        return .none

      default:
        return .none
      }
    }
    .ifLet(\App.State.selection, action: /App.Action.overview) {
      EmptyReducer()
        .ifLet(\Identified<Overview.State.ID, Overview.State?>.value, action: .self) {
          Overview()
        }
    }
    .ifLet(\App.State.sidebar.selection, action: /App.Action.transaction) {
      EmptyReducer()
        .ifLet(\Identified<App.State.Sidebar.MenuItem.ID, Transaction.State?>.value, action: .self) {
          Transaction()
        }
    }

    Scope(state: \.accountEditor, action: /App.Action.accountEditor) {
      AccountEdit()
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
