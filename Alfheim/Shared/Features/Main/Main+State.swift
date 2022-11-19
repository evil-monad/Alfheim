//
//  Main+State.swift
//  Alfheim
//
//  Created by alex.huo on 2021/12/18.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Domain

extension RealWorld.State {
  struct ContentState: Equatable {
    var isAccountComposerPresented: Bool
    var isSettingsPresented: Bool
  }

  var contentState: ContentState {
    get {
      ContentState(
        isAccountComposerPresented: isAddingAccount,
        isSettingsPresented: settings.isPresented
      )
    }
    set {
      isAddingAccount = newValue.isAccountComposerPresented
      settings.isPresented = newValue.isSettingsPresented
    }
  }
}

extension RealWorld.State {
  struct HomeState: Equatable {
    var rootAccounts: [Domain.Account]
    var isEditingAccount: Bool
  }

  var homeState: HomeState {
    get {
      HomeState(rootAccounts: rootAccounts, isEditingAccount: isEditingAccount)
    }
    set {
      isEditingAccount = newValue.isEditingAccount
    }
  }
}

extension RealWorld.State {
  struct RowState: Equatable {
    var selectionID: UUID?
  }

  var rowState: RowState {
    RowState(selectionID: selection?.id)
  }
}
