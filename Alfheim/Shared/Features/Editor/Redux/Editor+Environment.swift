//
//  AppEnvironment+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2021/2/8.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture
import CoreData

extension AppEnvironment {
  struct Editor {
    let validator: Validator
    var context: NSManagedObjectContext?

    init(validator: Validator, context: NSManagedObjectContext?) {
      self.validator = validator
      self.context = context
    }
  }
}

class Validator {
  func validate(state: AppState.Editor) -> Bool {
    guard state.source != nil, state.target != nil else {
      return false
    }
    let isAmountValid = state.amount.isValidAmount
    let isNotesValid = state.notes != ""
    let isValid = isAmountValid && isNotesValid
    return isValid
  }
}
