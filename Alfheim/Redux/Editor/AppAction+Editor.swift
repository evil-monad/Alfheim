//
//  AppAction+Editor.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/3/7.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppAction {
  enum Editor {
    case save(Alfheim.Transaction.Snapshot, mode: EditMode)
    case validate(valid: Bool)
    case edit(Alfheim.Transaction)
    case new
  }
}
