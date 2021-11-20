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

enum AppReducers {
  static let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
      struct CancelId: Hashable {}
      switch action {
      case .loadAll:
        return Effect
          .merge(
            AppEffects.Account.load(environment: environment),
            AppEffects.Transaction.fetch(environment: environment)
          )
      case .fetchAccounts:
        return AppEffects.Account.load(environment: environment)
          .cancellable(id: CancelId(), cancelInFlight: true)
      case .accountDidChange(let accounts):
        state.sidebar = AppState.Sidebar(accounts: accounts, selectionMenu: state.sidebar.selection?.id)
        state.overviews = IdentifiedArray(uniqueElements: accounts.map { AppState.Overview(account: $0) })
        if let id = state.selection?.id, let overview = state.overviews[id: id] {
          state.selection = Identified(overview, id: id)
        }
        return .none
      case .cleanup:
        return AppEffects.Account.delete(accounts: state.accounts, environment: environment)
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
        state.isEditingAcount = presenting
        return .none
      case .deleteAccount(let account):
        if !account.canDelete {
          return .none
        }
        return AppEffects.Account.delete(accounts: [account], environment: environment)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()
      case .selectMenu(selection: let item):
        if let id = item, let filter = AppState.QuickFilter(rawValue: id) {
          let allTransactions = state.sidebar.accounts.flatMap {
            $0.transactions(.only)
          }
          let uniqueTransactions = Domain.Transaction.uniqued(allTransactions)
          let transaction = AppState.Transaction(source: .list(title: filter.name, transactions: filter.filteredTransactions(uniqueTransactions)))
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
          state.overviews[id: selection.id] = AppState.Overview(account: overview.account)
        }
        return .none

      default:
        return .none
      }
    },
    AppReducers.Overview.reducer
      .optional()
      .pullback(state: \Identified.value, action: .self, environment: { $0 })
      .optional()
      .pullback(
        state: \AppState.selection,
        action: /AppAction.overview,
        environment: { $0 }
      ),
    AppReducers.AccountEditor.reducer.pullback(
      state: \AppState.accountEditor,
      action: /AppAction.accountEditor,
      environment: { AppEnvironment.Account(validator: AccountValidator(), context: $0.context) }
    ),
    AppReducers.Transaction.reducer
      .optional()
      .pullback(state: \Identified.value, action: .self, environment: { $0 })
      .optional()
      .pullback(
        state: \AppState.sidebar.selection,
        action: /AppAction.transaction,
        environment: { $0 }
    ),
    AppReducers.Settings.reducer.pullback(
      state: \AppState.settings,
      action: /AppAction.settings,
      environment: { $0 }
    )
//    AppReducers.Overview.reducer.forEach(
//      state: \AppState.overviews,
//      action: /AppAction.overview(id:action:),
//      environment: { $0 }
//    ),
//    AppReducers.Transaction.reducer.pullback(
//      state: \AppState.transaction,
//      action: /AppAction.transaction,
//      environment: { $0 }
//    ),
//    AppReducers.Editor.reducer
//      .pullback(
//        state: \.editor,
//        action: /AppAction.editor,
//        environment: { _ in AppEnvironment.Editor(validator: Validator()) }
//      )	
  )
}
