//
//  AppReducer+Overview.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

extension AppReducers {
  enum Overview {
    static let reducer = Reducer<AppState.Overview, AppAction.Overview, AppEnvironment>.combine(
      Reducer { state, action, environment in
        switch action {
        case .toggleNewTransaction(let presenting):
          state.editor.reset(.new)
          state.isEditorPresented = presenting

        case .showTrasactions(let active):
          state.isTransactionListActive = active
        default:
          ()
        }
        return .none
      },
      AppReducers.Editor.reducer
        .pullback(
          state: \.editor,
          action: /AppAction.Overview.editor,
          environment: { AppEnvironment.Editor(validator: Validator(), context: $0.context) }
        ),
      AppReducers.Transaction.reducer
        .pullback(
          state: \.transactions,
          action: /AppAction.Overview.transaction,
          environment: { $0 }
        )
    )
  }
}
