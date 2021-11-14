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
import Domain

struct AppState: Equatable {
  var overviews: IdentifiedArrayOf<Overview> = []
  var selection: Identified<Overview.ID, Overview?>?
  //var editor = Editor()

  var sidebar: Sidebar = Sidebar()

  var settings = Settings()

  var isAddingAccount: Bool = false
  var accountEditor = AccountEditor()
  var isEditingAcount: Bool = false
}

extension AppState {
  var accounts: [Domain.Account] {
    overviews.map { $0.account }
  }

  var rootAccounts: [Domain.Account] {
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

    var accounts: [Domain.Account]
    var menus: IdentifiedArrayOf<MenuItem>
    var selection: Identified<MenuItem.ID, Transaction?>?

    init(accounts: [Domain.Account] = [], selectionMenu: MenuItem.ID? = nil) {
      self.accounts = accounts

      let allTransactions = accounts.flatMap {
        $0.transactions(.only)
      }

      if let id = selectionMenu, let filter = AppState.QuickFilter(rawValue: id) {
        let uniqueTransactions = Domain.Transaction.uniqued(allTransactions)
        let transaction = AppState.Transaction(source: .list(title: filter.name, transactions: filter.filteredTransactions(uniqueTransactions)))
        self.selection = Identified(transaction, id: id)
      } else {
        self.selection = nil
      }

      var uniqueTransactions: [Domain.Transaction] = []
      var filter = Set<UUID>()
      for transaction in allTransactions {
        if !filter.contains(transaction.id) {
          uniqueTransactions.append(transaction)
          filter.insert(transaction.id)
        }
      }

      self.menus = [
        MenuItem(filter: .all, value: "\(uniqueTransactions.count)"),
        MenuItem(filter: .uncleared, value: "\(uniqueTransactions.filter { !$0.cleared }.count)"),
        MenuItem(filter: .repeating, value: "\(uniqueTransactions.filter { $0.repeated > 0 }.count)"),
        MenuItem(filter: .flagged, value: "\(uniqueTransactions.filter(\.flagged).count)"),
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

  func filteredTransactions(_ transations: [Domain.Transaction]) -> [Domain.Transaction] {
    switch self {
    case .all:
      return transations
    case .uncleared:
      return transations.filter { !$0.cleared }
    case .repeating:
      return transations.filter { $0.repeated > 0 }
    case .flagged:
      return transations.filter(\.flagged)
    }
  }
}
