//
//  AppAction+Account.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Domain

extension Account {
  enum Action {
    case update(Domain.Account)
  }
}
