//
//  Home.swift
//  Alfheim
//
//  Created by alex.huo on 2022/12/5.
//  Copyright © 2022 blessingsoft. All rights reserved.
//

import Foundation
import Domain
import IdentifiedCollections
import ComposableArchitecture

enum Destination: Equatable {
  case quickFilter(QuickFilter.ID)
  case overview(Overview.State.ID)
}

enum QuickFilter: Int, Hashable, Identifiable {
  case all, uncleared, repeating, flagged
  var id: Int { rawValue }
}

struct Home {
  enum Action {
  }
}

extension Home {
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

  struct State: Equatable {
    var accounts: [Domain.Account]
    var menus: IdentifiedArrayOf<MenuItem>
    var selection: Identified<MenuItem.ID, Transaction.State?>?

    init(accounts: [Domain.Account] = [], selectionMenu: MenuItem.ID? = nil) {
      self.accounts = accounts

      let allTransactions = accounts.flatMap {
        $0.transactions(.only)
      }

      if let id = selectionMenu, let filter = QuickFilter(rawValue: id) {
        let uniqueTransactions = Domain.Transaction.uniqued(allTransactions)
        let transaction = Transaction.State(source: .list(title: filter.name, transactions: filter.filteredTransactions(uniqueTransactions)))
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

extension QuickFilter {
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

  static let allCases: [QuickFilter] = [.all, .uncleared, .repeating, .flagged]

  static func identified(by id: QuickFilter.ID) -> QuickFilter {
    guard let result = allCases.first(where: { $0.id == id }) else {
      fatalError("Unknown Filter ID: \(id)")
    }
    return result
  }
}
