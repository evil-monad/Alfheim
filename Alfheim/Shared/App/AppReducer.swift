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
        state.sidebar = accounts
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
        state.isAccountEditorPresented = presenting
        return .none
      case .editAccount(let account):
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
      default:
        return .none
      }
    },
    AppReducers.Overview.reducer.forEach(
      state: \AppState.overviews,
      action: /AppAction.overview(id:action:),
      environment: { $0 }
    ),
    AppReducers.AccountEditor.reducer
      .pullback(
        state: \AppState.accountEditor,
        action: /AppAction.accountEditor,
        environment: { AppEnvironment.Account(validator: AccountValidator(), context: $0.context) }
      )
//    AppReducers.Editor.reducer
//      .pullback(
//        state: \.editor,
//        action: /AppAction.editor,
//        environment: { _ in AppEnvironment.Editor(validator: Validator()) }
//      )	
  )
}
