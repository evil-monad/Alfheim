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
  enum QuickFilter: Int, Hashable, Identifiable {
    case all, uncleared, repeating, flagged
    var id: Int { rawValue }
    var name: String {
      switch self {
      case .all: return "All"
      case .uncleared: return "Uncleared"
      case .repeating: return "Repeating"
      case .flagged: return "Flagged"
      }
    }
    var symbol: String {
      switch self {
      case .all: return "tray.circle.fill"
      case .uncleared: return "archivebox.circle.fill"
      case .repeating: return "repeat.circle.fill"
      case .flagged: return "flag.circle.fill"
      }
    }
  }

  struct Sidebar: Equatable {
    struct MenuItem: Equatable, Identifiable {
      let filter: QuickFilter
      let value: String

      var id: Int {
        filter.id
      }

      var name: String {
        filter.name
      }

      var symbol: String {
        filter.symbol
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
      var filter = Set<UUID>()
      for transaction in allTransactions {
        if !filter.contains(transaction.id) {
          uniqueTransactions.append(transaction)
          filter.insert(transaction.id)
        }
      }

      self.menuItems = [
        MenuItem(filter: .all, value: "\(uniqueTransactions.count)"),
        MenuItem(filter: .uncleared, value: "\(uniqueTransactions.filter(\.alne.uncleared).count)"),
        MenuItem(filter: .repeating, value: "\(uniqueTransactions.filter(\.alne.repeating).count)"),
        MenuItem(filter: .flagged, value: "66"),
      ]
    }
  }
}
