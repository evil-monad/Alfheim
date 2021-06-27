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
          state.isEditorPresented = presenting
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
        )
    )
  }
//  enum Overview {
//    static func reduce(state: AppState, action: AppAction.Overview) -> (AppState, AppCommand?) {
//      var appState = state
//      let appCommand: AppCommand? = nil
//
//      switch action {
//      case .toggleNewTransaction(let presenting):
//        appState.overview.isEditorPresented = presenting
//        appState.editor.isValid = false // Important! need set here
//        appState.editor.validator.reset(.new)
//      case .editTransaction(let transaction):
//        appState.overview.selectedTransaction = transaction
//        appState.overview.editingTransaction = true
//        appState.editor.isValid = true // Important! need set here
//        appState.editor.validator.reset(.edit(transaction))
//      case .editTransactionDone:
//        appState.overview.selectedTransaction = nil
//        appState.overview.editingTransaction = false
//        appState.editor.isValid = false // Important! need set here
//        appState.editor.validator.reset(.new)
//      case .toggleStatistics(let presenting):
//        ()
////        if presenting, state.shared.periodTransactions.isEmpty {
////          break
////        }
////        appState.overview.isStatisticsPresented = presenting
////        appState.statistics.transactions = state.shared.periodTransactions
////        appState.statistics.period = state.shared.period
////        appState.statistics.timeRange = state.shared.timeRange
//      case .toggleAccountDetail(let presenting):
////        appState.accountDetail.account = appState.shared.account // save draft
//        appState.overview.isAccountDetailPresented = presenting
//      case .toggleSettings(let presenting):
//        appState.overview.isSettingsPresented = presenting
//      case .switchPeriod:
//        ()
////        switch state.shared.period {
////        case .weekly:
////          appState.shared.period = .monthly
////        case .monthly:
////          appState.shared.period = .yearly
////        case .yearly:
////          appState.shared.period = .weekly
////        }
//      case .onDetailed(let active):
//        appState.overview.isTransactionListActive = active
//      }
//
//      return (appState, appCommand)
//    }
//  }
}
