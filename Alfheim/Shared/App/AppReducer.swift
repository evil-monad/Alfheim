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

enum AppReducers {
  static let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
      switch action {
      case .load:
        return AppEffects.Account.load(environment: environment)
      case .didLoad(let accounts):
        let selection = state.sidebar.selection
        state.sidebar = AppState.Sidebar(accounts: accounts)
        state.sidebar.selection = selection
        state.overviews = IdentifiedArray(uniqueElements: accounts.map { AppState.Overview(account: $0) })
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
        guard state.sidebar.selection?.id != item else {
          return .none
        }
        if let id = item, let filter = AppState.QuickFilter(rawValue: id) {
          let allTransactions = state.sidebar.accounts.flatMap {
            $0.transactions(.only)
          }
          let uniqueTransactions = Alfheim.Transaction.uniqued(allTransactions)
          state.transaction = AppState.Transaction(filter: .list(title: filter.name, transactions: filter.filteredTransactions(uniqueTransactions)))
          state.sidebar.selection = Identified(nil, id: id)
        } else {
          state.transaction = AppState.Transaction(filter: .none)
          state.sidebar.selection = nil
        }
        return .none

      default:
        return .none
      }
    },
    AppReducers.Overview.reducer.forEach(
      state: \AppState.overviews,
      action: /AppAction.overview(id:action:),
      environment: { $0 }
    ),
    AppReducers.AccountEditor.reducer.pullback(
      state: \AppState.accountEditor,
      action: /AppAction.accountEditor,
      environment: { AppEnvironment.Account(validator: AccountValidator(), context: $0.context) }
    ),
    AppReducers.Transaction.reducer.pullback(
      state: \AppState.transaction,
      action: /AppAction.transaction,
      environment: { $0 }
    ),
    AppReducers.Settings.reducer.pullback(
      state: \AppState.settings,
      action: /AppAction.settings,
      environment: { $0 }
    )
//    AppReducers.Editor.reducer
//      .pullback(
//        state: \.editor,
//        action: /AppAction.editor,
//        environment: { _ in AppEnvironment.Editor(validator: Validator()) }
//      )	
  )
}
