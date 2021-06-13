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

enum AppReducers {
  static let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
      switch action {
      case .load:
        return AppEffects.Account.load(environment: environment)
      case .loaded(let accounts):
        state.sidebar = accounts
        state.overviews = accounts.map { AppState.Overview(account: $0) }
        return .none
      case .cleanup:
        return AppEffects.Account.delete(accounts: state.accounts, environment: environment)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()
      case .new:
        let expenses = Alfheim.Account(context: environment.context!)
        expenses.id = UUID()
        expenses.name = "Food"
        expenses.introduction = "Expenses account are where you spend money for (e.g. food)."
        expenses.group = Alne.Account.Group.expenses.name
        expenses.currency = Int16(0)
        expenses.tag = "#FF2601"
        expenses.emoji = "🍉"
        expenses.parent = state.accounts.first

        return AppEffects.Account.create(account: expenses, context: environment.context)
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
      action: /AppAction.overview(index:action:),
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
