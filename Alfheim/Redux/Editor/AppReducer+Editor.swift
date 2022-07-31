//
//  AppReducer+Editor.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppReducers {
  enum Editor {
    static func reduce(state: AppState, action: AppAction.Editor) -> (AppState, AppCommand?) {
      var appState = state
      var appCommand: AppCommand? = nil

      switch action {
      case .new:
        appState.editor.validator.reset(.new)
      case .edit(let transaction):
        appState.editor.validator.reset(.edit(transaction))
      case .save(let snashot, let mode):
        appState.editor.validator.reset(.new)
        switch mode {
        case .new:
          appCommand = AppCommands.CreateTransactionCommand(transaction: snashot)
        case .update:
          appCommand = AppCommands.UpdateTransactionCommand(transaction: snashot)
        case .delete:
          fatalError("Editor can't delete")
        }
      case .validate(let valid):
        appState.editor.isValid = valid
      }

      return (appState, appCommand)
    }
  }
}
