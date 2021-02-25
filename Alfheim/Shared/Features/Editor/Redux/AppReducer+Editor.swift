//
//  AppReducer+Editor.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension AppReducers {
  enum Editor {
    static let reducer = Reducer<AppState.Editor, AppAction.Editor, AppEnvironment.Editor> { state, action, environment in

      struct ValidationId: Hashable {}

      switch action {
      case .new:
        state.reset(.new)
      case .edit(let transaction):
        state.reset(.edit(transaction))
      case let .save(snapshot, mode):
        switch mode {
        case .new:
          return AppEffects.Transaction.create(snapshot: snapshot, context: environment.context)
            .replaceError(with: false)
            .ignoreOutput()
            .eraseToEffect()
            .fireAndForget()
        case .update:
          return AppEffects.Transaction.update(transaction: snapshot, context: environment.context)
            .replaceError(with: false)
            .ignoreOutput()
            .eraseToEffect()
            .fireAndForget()
        case .delete:
          fatalError("Editor can't delete")
        }
      case .loadAccounts:
        return AppEffects.Editor.loadAccounts(environment: environment)
      case .loadedAccounts(let accounts):
        state.accounts = accounts
      case .changed(let field):
        switch field {
        case .amount(let value):
          state.amount = value
        case .currency(let value):
          state.currency = value
        case .date(let value):
          state.date = value
        case .notes(let value):
          state.notes = value
        case .payee(let payee):
          state.payee = payee
        case .number(let number):
          state.number = number
        case .repeated(let repeated):
          state.repeated = repeated
        case .cleared(let cleared):
          state.cleared = cleared
        case .target(let account):
          if let a = account {
            state.target = a
          }
//          let persistence = Persistences.Account(context: environment.context!)
//          state.target = persistence.account(withID: id)
        case .source(let id):
          if let id = id {
          let persistence = Persistences.Account(context: environment.context!)
            state.source = persistence.account(withID: id)
          }
        case .attachment:
          state.attachments = []
        }
        state.isValid = environment.validator.validate(state: state)
      }
      return .none
    }
  }
}
