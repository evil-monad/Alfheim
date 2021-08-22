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

  var sidebar: Sidebar = Sidebar()

  var isAddingAccount: Bool = false
  var accountEditor = AccountEditor()
  var isEditingAcount: Bool = false
}

extension AppState {
  var accounts: [Alfheim.Account] {
    overviews.map { $0.account }
  }

  var rootAccounts: [Alfheim.Account] {
    accounts.filter { $0.root }
  }
}

extension AppState {
  struct Sidebar: Equatable {
    struct MenuItem: Equatable, Identifiable {
      let type: ItemType
      let text: String
      let value: String
      let symbol: String

      var id: Int {
        type.id
      }

      enum ItemType: Int, Identifiable {
        case all, uncleared, repeating, flagged
        var id: Int { rawValue }
      }
    }

    var accounts: [Alfheim.Account]
    var menuItems: [MenuItem]
    init(accounts: [Alfheim.Account] = []) {
      self.accounts = accounts

      let allTransactions = accounts.flatMap {
        $0.transactions(.only)
      }
      var uniqueTransactions: [Alfheim.Transaction] = []
      let filter = Set<UUID>()
      for transaction in allTransactions {
        if filter.contains(transaction.id) {
          uniqueTransactions.append(transaction)
        }
      }

      self.menuItems = [
        MenuItem(type: .all, text: "All", value: "\(uniqueTransactions.count)", symbol: "tray.circle.fill"),
        MenuItem(type: .uncleared, text: "Uncleared", value: "\(uniqueTransactions.filter(\.cleared).count)", symbol: "archivebox.circle.fill"),
        MenuItem(type: .repeating, text: "Repeating", value: "\(uniqueTransactions.filter { $0.repeated > 0 }.count)", symbol: "repeat.circle.fill"),
        MenuItem(type: .flagged, text: "Flagged", value: "66", symbol: "flag.circle.fill"),
      ]
    }
  }
}
