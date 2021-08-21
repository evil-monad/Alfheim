//
//  Account+Environment.swift
//  Account+Environment
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

extension AppEnvironment {
  struct Account {
    let validator: AccountValidator
    var context: NSManagedObjectContext?

    init(validator: AccountValidator, context: NSManagedObjectContext?) {
      self.validator = validator
      self.context = context
    }
  }
}

class AccountValidator {
  func validate(state: AppState.AccountEditor) -> Bool {
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
