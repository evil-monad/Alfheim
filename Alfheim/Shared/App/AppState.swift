//
//  AppEnvironment.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture

struct AppState: Equatable {
  var overviews: IdentifiedArrayOf<Overview> = []
  //var editor = Editor()

  var sidebar: Sidebar = Sidebar()
  var transaction = Transaction(filter: .none)

  var settings = Settings()

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
    var menus: IdentifiedArrayOf<MenuItem>
    var selection: Identified<MenuItem.ID, MenuItem?>?

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

      self.menus = [
        MenuItem(filter: .all, value: "\(uniqueTransactions.count)"),
        MenuItem(filter: .uncleared, value: "\(uniqueTransactions.filter(\.alne.uncleared).count)"),
        MenuItem(filter: .repeating, value: "\(uniqueTransactions.filter(\.alne.repeating).count)"),
        MenuItem(filter: .flagged, value: "\(uniqueTransactions.filter(\.alne.flagged).count)"),
      ]
    }
  }
}

extension AppState.QuickFilter {
  var symbol: String {
    switch self {
    case .all: return "tray.circle.fill"
    case .uncleared: return "archivebox.circle.fill"
    case .repeating: return "repeat.circle.fill"
    case .flagged: return "flag.circle.fill"
    }
  }

  var name: String {
    switch self {
    case .all: return "All"
    case .uncleared: return "Uncleared"
    case .repeating: return "Repeating"
    case .flagged: return "Flagged"
    }
  }

  func filteredTransactions(_ transations: [Alfheim.Transaction]) -> [Alfheim.Transaction] {
    switch self {
    case .all:
      return transations
    case .uncleared:
      return transations.filter(\.alne.uncleared)
    case .repeating:
      return transations.filter(\.alne.repeating)
    case .flagged:
      return transations.filter(\.alne.flagged)
    }
  }
}
