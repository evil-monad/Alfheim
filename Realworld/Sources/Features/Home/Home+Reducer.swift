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

enum QuickFilter: Int, Hashable, Identifiable {
  case all, uncleared, repeating, flagged
  var id: Int { rawValue }
}

@Reducer
public struct Home {
  @ObservableState
  public struct State: Equatable {
    var accounts: [Domain.Account]
    var menus: IdentifiedArrayOf<MenuItem>
    var selection: Selection?
    @Presents var destination: Destination.State?

    init(accounts: [Domain.Account] = [], selection: Selection? = nil) {
      self.accounts = accounts

      let allTransactions = accounts.flatMap {
        $0.transactions(.depth)
      }
      let uniqueTransactions: [Domain.Transaction] = allTransactions.uniqued()

      self.menus = [
        MenuItem(filter: .all, value: "\(uniqueTransactions.count)"),
        MenuItem(filter: .uncleared, value: "\(uniqueTransactions.filter { !$0.cleared }.count)"),
        MenuItem(filter: .repeating, value: "\(uniqueTransactions.filter { $0.repeated > 0 }.count)"),
        MenuItem(filter: .flagged, value: "\(uniqueTransactions.filter(\.flagged).count)"),
      ]
    }

    var rootAccounts: [Domain.Account] {
      accounts.filter { $0.root }
    }
  }

  public enum Action: Equatable {
    enum Delegate: Equatable {
      case delete(Domain.Account)
      case edit(Domain.Account?)
    }

    case onAppear
    case select(Selection?)
    case destination(PresentationAction<Destination.Action>)

    case delete(Domain.Account)
    case edit(Domain.Account)

    case cancelEdit
    case editDone
  }

  public enum Selection: Equatable, Hashable {
    case menu(MenuItem)
    case account(Domain.Account)
  }

  @Dependency(\.persistent) var persistent
  @Dependency(\.continuousClock) var clock

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case edit(EditAccount.State)
    }
    public enum Action: Equatable {
      case edit(EditAccount.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: \.edit, action: \.edit) {
        EditAccount()
      }
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      enum CancelID: Hashable {
        case fetch
      }

      switch action {
      case .onAppear:
        return .run { send in
          try await self.clock.sleep(for: .milliseconds(200))
          await send(.select(nil), animation: .default)
        }

      case .select(.none):
        state.selection = nil
        return .concatenate(.cancel(id: CancelID.fetch))

      case let .select(.some(.account(account))):
        state.selection = .account(account)
        return .none

      case let .select(.some(.menu(item))):
        state.selection = .menu(item)
        return .none

      case .edit(let account):
        state.destination = .edit(EditAccount.State(account: account))
        return .none

      case .destination(.presented(.edit(.delegate))):
        state.destination = nil
        return .none

      case .delete(let account):
        if !account.canDelete {
          return .none
        }
        return .run { _ in
          try await persistent.delete(account)
        }

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }
}

extension Home {
  public struct MenuItem: Equatable, Identifiable, Hashable {
    let filter: QuickFilter
    let value: String

    public var id: Int {
      filter.id
    }

    var name: String {
      filter.name
    }

    var symbol: String {
      filter.symbol
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

  static let allCases: [QuickFilter] = [.all, .uncleared, .repeating, .flagged]

  static func identified(by id: QuickFilter.ID) -> QuickFilter {
    guard let result = allCases.first(where: { $0.id == id }) else {
      fatalError("Unknown Filter ID: \(id)")
    }
    return result
  }
}

extension QuickFilter {
  var transactionFilter: Domain.Transaction.Filter {
    switch self {
    case .all: return .all
    case .uncleared: return .uncleared
    case .repeating: return .repeating
    case .flagged: return .flagged
    }
  }
}
