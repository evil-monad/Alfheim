//
//  Account+Environment.swift
//  Account+Environment
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct AccountEnvironment: DependencyKey {
  let validator: AccountValidator

  static let liveValue = AccountEnvironment(validator: AccountValidator())
}

final class AccountValidator {
  func validate(state: EditAccount.State) -> Bool {
    guard !state.name.isEmpty, state.parent != nil else {
      return false
    }
    let isGroupValid = !state.group.isEmpty
    let isIntroductionValid = !state.introduction.isEmpty
    let isTagValid = !state.tag.isEmpty
    let isValid = isGroupValid && isIntroductionValid && isTagValid
    return isValid
  }
}

extension DependencyValues {
  var account: AccountEnvironment {
    get { self[AccountEnvironment.self] }
    set { self[AccountEnvironment.self] = newValue }
  }
}
