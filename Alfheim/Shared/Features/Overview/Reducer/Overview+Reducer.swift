//
//  AppReducer+Overview.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain
import Persistence

struct Overview: Reducer {
  @Dependency(\.persistent) var persistent

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      enum CancelID: Hashable {
        case observe
      }
      switch action {
      case .onAppear:
        guard !state.hasInitialized else { break }
        state.hasInitialized = true
        return .run { [state] send in
          let stream: AsyncStream<[Domain.Account]> = persistent.observe(
            Domain.Account.all.where(Domain.Account.identifier == state.account.id),
            relationships: Domain.Account.relationships
          )
          for try await accounts in stream where !accounts.isEmpty {
            assert(accounts.count == 1 && accounts.first!.id == state.account.id)
            if let account = accounts.first {
              await send(.accountDidChange(account))
            }
          }
        }
        .cancellable(id: CancelID.observe)
      case .accountDidChange(let account):
        state.account.targets = account.targets
        state.account.sources = account.sources
        state.editor = Editor.State(target: state.account.summary)
        state.transactions = Transaction.State(source: .accounted(account: state.account, interval: state.timeInterval))
      case .toggleNewTransaction(let presenting):
        state.editor.reset(.new)
        state.isEditorPresented = presenting

      default:
        ()
      }
      return .none
    }

    Scope(state: \.editor, action: /Action.editor) {
      Editor()
    }

    Scope(state: \.transactions, action: /Action.transaction) {
      Transaction()
    }
  }
}
