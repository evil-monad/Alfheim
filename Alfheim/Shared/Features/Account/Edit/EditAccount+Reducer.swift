//
//  EditAccount+Reducer.swift
//  Alfheim
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Persistence

struct EditAccount: ReducerProtocol {
  @Dependency(\.persistent) var persistent
  @Dependency(\.account) var env

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    struct ValidationId: Hashable {}

    switch action {
    case .new:
      state.reset(.new)
    case .edit(let account):
      state.reset(.edit(account))
    case let .save(snapshot, mode):
      switch mode {
      case .new:
        return Account.Effects.create(snapshot: snapshot, context: persistent.context)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()
      case .update:
        return Account.Effects.update(snapshot: snapshot, context: persistent.context)
          .replaceError(with: false)
          .ignoreOutput()
          .eraseToEffect()
          .fireAndForget()
      case .delete:
        fatalError("Editor can't delete")
      }
    case .loadAccounts:
      return Account.Effects.loadAccounts(context: persistent.context)
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
      state.isValid = env.validator.validate(state: state)
    }
    return .none
  }
}
