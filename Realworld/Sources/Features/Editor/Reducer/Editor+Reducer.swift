//
//  AppReducer+Editor.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Persistence
import Domain

extension Editor {
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      struct ValidationId: Hashable {}

      switch action {
      case .new:
        state.reset(.new)
      case .edit(let transaction):
        state.reset(.edit(transaction))
      case let .save(model, mode):
        switch mode {
        case .new:
          return .run { send in
            try await persistent.insert(model, relationships: [
              (keyPath: \.target, value: Domain.Account(model.target)),
              (keyPath: \.source, value: Domain.Account(model.source)),
            ])
          }
        case .update:
          return .run { send in
            try await persistent.update(model, relationships: [
              (keyPath: \.target, value: Domain.Account(model.target)),
              (keyPath: \.source, value: Domain.Account(model.source)),
            ])
          }
        case .delete:
          fatalError("Editor can't delete")
        }
      case .loadAccounts:
        return .run { send in
          let accounts = try await persistent.fetch(Domain.Account.all.sort("name", ascending: true)) { Domain.Account.makeTree($0) }
          await send(.didLoadAccounts(accounts))
        }
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
}
