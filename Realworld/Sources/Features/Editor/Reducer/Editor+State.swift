//
//  AppState+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import CoreData
import ComposableArchitecture
import Domain
import Database
import Persistence
import Kit

@Reducer
public struct Editor {
  @Dependency(\.persistent) var persistent
  @Dependency(\.validator) var validator

  public enum Action: BindableAction, Equatable {
    case save(Domain.Transaction, mode: App.Action.EditMode)
    case edit(Domain.Transaction)
    case new
    case binding(BindingAction<State>)
    case loadAccounts
    case didLoadAccounts([Domain.Account])
    case focused(Editor.State.FocusField?)
  }
  
  /// Composer, editor state
  @ObservableState
  public struct State: Equatable {
    public enum Mode: Equatable {
      case new
      case edit(Domain.Transaction)

      var isNew: Bool {
        switch self {
        case .new:
          return true
        default:
          return false
        }
      }
    }

    public enum FocusField: Hashable {
      case amount
      case notes
      case payee
      case number
    }

    var mode: Mode = .new
    var amount: String = ""
    var currency: Currency = .cny

    var date: Date = Date()
    var notes: String = ""
    var payee: String = ""
    var number: String = ""

    var repeated: Repeat = .never
    var cleared: Bool = true

    var target: Domain.Account.Summary? = nil
    var source: Domain.Account.Summary? = nil
    var attachments: [Domain.Attachment] = []

    var accounts: [Domain.Account] = []

    var isValid: Bool = false
    var focusField: FocusField? = nil

    var isNew: Bool {
      return mode.isNew
    }

    mutating func reset(_ mode: Mode) {
      switch mode {
      case .new:
        amount = ""
        currency = .cny
        date = Date()
        notes = ""
        payee = ""
        number = ""
        repeated = .never
        cleared = true
        source = nil
        // target = nil
        attachments = []
      case .edit(let transaction):
        amount = "\(transaction.amount)"
        currency = transaction.currency
        date = transaction.date
        notes = transaction.notes
        payee = transaction.payee ?? ""
        number = transaction.number ?? ""
        repeated = Repeat(rawValue: Int(transaction.repeated)) ?? .never
        cleared = transaction.cleared
        source = transaction.source
        target = transaction.target
        attachments = transaction.attachments
      }
      self.mode = mode
    }

    var transaction: Domain.Transaction {
      switch mode {
      case .new:
        return Domain.Transaction(
          id: UUID(),
          amount: Double(amount)!,
          currency: Int16(currency.rawValue),
          date: date,
          notes: notes,
          payee: payee,
          number: number,
          repeated: Int16(repeated.rawValue),
          cleared: cleared,
          flagged: false,
          target: target!,
          source: source!,
          attachments: attachments
        )
      case .edit(let transaction):
        return Domain.Transaction(
          id: transaction.id,
          amount: Double(amount)!,
          currency: Int16(currency.rawValue),
          date: date,
          notes: notes,
          payee: payee,
          number: number,
          repeated: Int16(repeated.rawValue),
          cleared: cleared,
          flagged: false,
          target: target!,
          source: source!,
          attachments: attachments
        )
      }
    }

    var groupedRootAccounts: [String: [Domain.Account]] {
      return rootAccounts.grouped(by: { $0.group.rawValue })
    }

    var rootAccounts: [Domain.Account] {
      accounts.filter { $0.root }.flatMap { $0.children ?? [] }
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      struct ValidationId: Hashable {}

      switch action {
      case .new:
        state.reset(.new)
      case .edit(let transaction):
        state.reset(.edit(transaction))
      case let .save(model, mode):
        switch mode {
        case .new:
          return .run { send in
            try await persistent.insert(model, relationships: [
              (keyPath: \.target, value: Domain.Account(model.target)),
              (keyPath: \.source, value: Domain.Account(model.source)),
            ])
          }
        case .update:
          return .run { send in
            try await persistent.update(model, relationships: [
              (keyPath: \.target, value: Domain.Account(model.target)),
              (keyPath: \.source, value: Domain.Account(model.source)),
            ])
          }
        case .delete:
          fatalError("Editor can't delete")
        }
      case .loadAccounts:
        return .run { send in
          let accounts = try await persistent.fetch(Domain.Account.all.sort("name", ascending: true)) { Domain.Account.makeTree($0) }
          await send(.didLoadAccounts(accounts))
        }
      case .didLoadAccounts(let accounts):
        state.accounts = accounts
        break
      case .binding:
        state.isValid = validator.validate(state: state)
      case .focused(let field):
        state.focusField = field
      }
      return .none
    }
  }

}

extension String {
  var isValidAmount: Bool {
    self != "" && Double(self) != nil
  }
}
