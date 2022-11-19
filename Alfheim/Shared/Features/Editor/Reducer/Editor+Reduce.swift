//
//  AppReducer+Editor.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension Editor {
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    struct ValidationId: Hashable {}

    switch action {
    case .new:
      state.reset(.new)
    case .edit(let transaction):
      state.reset(.edit(transaction))
    case let .save(model, mode):
      switch mode {
      case .new:
        return Transaction.Effects.create(model: model, context: context)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()
      case .update:
        return Transaction.Effects.update(model: model, context: context)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()
      case .delete:
        fatalError("Editor can't delete")
      }
    case .loadAccounts:
      return Effects.loadAccounts(context: context)
    case .didLoadAccounts(let accounts):
      state.accounts = accounts
      break
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
      case .source(let account):
        if let account = account {
          state.source = account
        }
      case .target(let account):
        if let account = account {
          state.target = account
        }
      case .attachment:
        state.attachments = []
      }
      state.isValid = validator.validate(state: state)
    case .focused(let field):
      state.focusField = field
    }
    return .none
  }
}
