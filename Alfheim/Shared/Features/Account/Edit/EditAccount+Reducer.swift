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
import Domain

struct EditAccount: Reducer {
  @Dependency(\.persistent) var persistent
  @Dependency(\.account) var env

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      struct ValidationId: Hashable {}

      switch action {
      case .new:
        state.reset(.new)

      case .edit(let account):
        state.reset(.edit(account))

      case let .save(snapshot, mode):
        switch mode {
        case .new:
          return .run { send in
            try await persistent.insert(snapshot, relationships: [(keyPath: \.parent, value: snapshot.parent)])
            await send(.delegate(.saved))
          }
        case .update:
          return .run { send in
            try await persistent.update(snapshot, relationships: [(keyPath: \.parent, value: snapshot.parent)])
            await send(.delegate(.saved))
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

      default:
        return .none
      }
      return .none
    }
  }
}
