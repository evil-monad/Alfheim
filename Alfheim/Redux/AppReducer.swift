//
//  Reducer.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

struct AppReducer {
  func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
    var appState = state
    var appCommand: AppCommand? = nil

    switch action {
    case .overviews(let subaction):
      switch subaction {
      case .toggleNewTransaction(let presenting):
        appState.overview.viewState.isEditorPresented = presenting
      case .editTransaction(let transaction):
        appState.overview.viewState.selectedTransaction = transaction
      case .editTransactionDone:
        appState.overview.viewState.selectedTransaction = nil
      case .toggleStatistics(let presenting):
        appState.overview.viewState.isStatisticsPresented = presenting
      case .toggleAccountDetail(let presenting):
        appState.accountDetail.account = appState.account
        appState.overview.viewState.isAccountDetailPresented = presenting
      case .switchPeriod:
        switch state.overview.period {
        case .weekly:
          appState.overview.period = .montly
        case .montly:
          appState.overview.period = .yearly
        case .yearly:
          appState.overview.period = .weekly
        }
      }
    case .settings:
      ()
    case .accounts(let subaction):
      switch subaction {
      case .save(let account):
        appState.account = account
        appState.overview.account = account
        appState.overview.viewState.isAccountDetailPresented = false
      }
    @unknown default:
      fatalError("unknown")
    }

    return (appState, appCommand)
  }
}
