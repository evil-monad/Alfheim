//
//  AccountEditor+State.swift
//  AccountEditor+State
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension AppState {
  /// Composer, editor state
  struct AccountEditor: Equatable {
    enum Mode: Equatable {
      case new
      case edit(Alfheim.Account)

      var isNew: Bool {
        switch self {
        case .new:
          return true
        default:
          return false
        }
      }
    }

    var accounts: [Alfheim.Account] = []

    var mode: Mode = .new
    var isValid: Bool = false
    var isNew: Bool {
      return mode.isNew
    }

    var name: String = ""
    var introduction: String = ""
    var group: String = ""
    var currency: Currency = .cny
    var tag: String?
    var emoji: String?
    var parent: Alfheim.Account?
  }
}

extension AppState.AccountEditor {
  mutating func reset(_ mode: Mode) {
    switch mode {
    case .new:
      name = ""
      introduction = ""
      group = ""
      currency = .cny
      tag = nil
      emoji = nil
      parent = nil
    case .edit(let account):
      name = account.name
      introduction = account.introduction
      group = account.group
      currency = Currency(rawValue: Int(account.currency)) ?? .cny
      tag = account.tag
      emoji = account.emoji
      parent = account.parent
    }
    self.mode = mode
  }
}

extension AppState.AccountEditor {
  func makeSnapshot() -> Alfheim.Account.Snapshot {
    let snapshot: Alfheim.Account.Snapshot
    switch mode {
    case .new:
      snapshot = Alfheim.Account.Snapshot(
        name: name,
        introduction: introduction,
        group: group,
        currency: Int16(currency.rawValue),
        tag: tag,
        emoji: emoji,
        parent: parent
      )
    case .edit(let account):
      account.name = name
      account.introduction = introduction
      account.group = group
      account.currency = Int16(currency.rawValue)
      account.tag = tag
      account.emoji = emoji
      account.parent = parent
      snapshot = Alfheim.Account.Snapshot(account)
    }
    return snapshot
  }

  var snapshot: Alfheim.Account.Snapshot {
    makeSnapshot()
  }

  var groupedRootAccounts: [String: [Alfheim.Account]] {
    return rootAccounts.grouped(by: { $0.group })
  }

  var rootAccounts: [Alfheim.Account] {
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
