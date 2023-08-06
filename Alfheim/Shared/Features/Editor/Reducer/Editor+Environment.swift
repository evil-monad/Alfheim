//
//  AppEnvironment+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/8.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import ComposableArchitecture

final class Validator: DependencyKey {
  static var liveValue: Validator {
    return Validator()
  }

  func validate(state: Editor.State) -> Bool {
    guard state.source != nil, state.target != nil else {
      return false
    }
    let isAmountValid = state.amount.isValidAmount
    let isNotesValid = state.notes != ""
    let isValid = isAmountValid && isNotesValid
    return isValid
  }
}

extension DependencyValues {
  var validator: Validator {
    get { self[Validator.self] }
    set { self[Validator.self] = newValue }
  }
}
