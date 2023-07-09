//
//  AppReducer+Overview.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct Overview: ReducerProtocol {
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
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
