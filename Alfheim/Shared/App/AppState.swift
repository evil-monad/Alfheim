//
//  AppEnvironment.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import IdentifiedCollections

struct AppState: Equatable {
  var overviews: IdentifiedArrayOf<Overview> = []
  //var editor = Editor()

  var sidebar: [Alfheim.Account] = []

  var isAccountEditorPresented: Bool = false
  var accountEditor = AccountEditor()
}

extension AppState {
  var accounts: [Alfheim.Account] {
    overviews.map { $0.account }
  }

  var rootAccounts: [Alfheim.Account] {
    accounts.filter { $0.root }
  }
}
