//
//  AccountEditor+Reducer.swift
//  AccountEditor+Reducer
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension AppReducers {
  enum AccountEditor {
    static let reducer = Reducer<AppState.AccountEditor, AppAction.AccountEditor, AppEnvironment.Account> { state, action, environment in

      struct ValidationId: Hashable {}

      switch action {
      case .new:
        state.reset(.new)
      case .edit(let account):
        state.reset(.edit(account))
      case let .save(snapshot, mode):
        switch mode {
        case .new:
          return AppEffects.Account.create(snapshot: snapshot, environment: environment)
            .replaceError(with: false)
            .ignoreOutput()
            .eraseToEffect()
            .fireAndForget()
        case .update:
          return AppEffects.Account.update(snapshot: snapshot, environment: environment)
            .replaceError(with: false)
            .ignoreOutput()
            .eraseToEffect()
            .fireAndForget()
        case .delete:
          fatalError("Editor can't delete")
        }
      case .loadAccounts:
        return AppEffects.Account.loadAccounts(environment: environment)
      case .didLoadAccounts(let accounts):
        state.accounts = accounts
      case .changed(let field):
        switch field {
        case .name(let value):
          state.name = value
        case .introduction(let value):
          state.introduction = value
        case .currency(let value):
          state.currency = value
        case .tag(let value):
          state.tag = value
        case .emoji(let value):
          state.emoji = value
        case .parent(let value):
          state.parent = value
          state.group = value?.group.rawValue ?? ""
        }
        state.isValid = environment.validator.validate(state: state)
      }
      return .none
    }
  }
}
