//
//  EditAccount+State.swift
//  Alfheim
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import SwiftUI
import Domain

extension EditAccount {
  public enum Mode {
    case new
    case edit
  }

  /// Composer, editor state
  public struct State: Equatable {
    enum Mode: Equatable {
      case new
      case edit(Domain.Account)

      var isNew: Bool {
        switch self {
        case .new:
          return true
        default:
          return false
        }
      }
    }

    enum FocusField: String, Hashable {
      case name
      case introduction
    }

    init(account: Domain.Account) {
      name = account.name
      introduction = account.introduction
      group = account.group.rawValue
      currency = account.currency
      tag = account.tag
      emoji = account.emoji
      parent = account.parent?.summary
      mode = .edit(account)
    }

    public init() {
    }

    var accounts: [Domain.Account] = []

    var mode: Mode = .new
    var isValid: Bool = false
    var isNew: Bool {
      return mode.isNew
    }
    var focusField: FocusField? = nil

    var name: String = ""
    var introduction: String = ""
    var group: String = ""
    var currency: Currency = .cny
    var tag: String = ""
    var emoji: String?
    var parent: Domain.Account.Summary?
  }
}

extension EditAccount.State {
  mutating func reset(_ mode: Mode) {
    switch mode {
    case .new:
      name = ""
      introduction = ""
      group = ""
      currency = .cny
      tag = ""
      emoji = nil
      parent = nil
    case .edit(let account):
      name = account.name
      introduction = account.introduction
      group = account.group.rawValue
      currency = account.currency
      tag = account.tag
      emoji = account.emoji
      parent = account.parent?.summary
    }
    self.mode = mode
  }
}

extension EditAccount.State {
  func makeAccount() -> Domain.Account {
    switch mode {
    case .new:
      var snapshot = Domain.Account(
        id: UUID(),
        name: name,
        introduction: introduction,
        group: Domain.Account.Group(rawValue: group)!,
        currency: currency,
        tag: tag,
        emoji: emoji,
        targets: [],
        sources: []
      )
      snapshot.parents = parent.map(Domain.Account.init).map { [$0] }
      return snapshot
    case .edit(let account):
      var snapshot = Domain.Account(
        id: account.id,
        name: name,
        introduction: introduction,
        group: group,
        currency: currency.rawValue,
        tag: tag,
        emoji: emoji,
        targets: account.targets,
        sources: account.sources
      )

      snapshot.children = account.children
      snapshot.parents = parent.map(Domain.Account.init).map { [$0] }
      return snapshot
    }
  }

  var snapshot: Domain.Account {
    makeAccount()
  }

  var groupedRootAccounts: [String: [Domain.Account]] {
    return rootAccounts.grouped(by: { $0.group.rawValue })
  }

  var rootAccounts: [Domain.Account] {
    accounts.filter { $0.root }
  }
}

/*
 enum EditMode<T> {
   case new
   case edit(T)
 }

 extension EditMode: Equatable where T: Equatable {}
 */
