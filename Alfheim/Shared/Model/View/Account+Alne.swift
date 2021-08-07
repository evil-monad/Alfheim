//
//  Account+Alne.swift
//  Account+Alne
//
//  Created by alex.huo on 2021/8/1.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension AlneWorld where Base: Alfheim.Account {
  var group: Alne.Account.Group {
    return Alne.Account.Group(rawValue: base.group)!
  }

  var currency: Alne.Currency {
    return Alne.Currency(rawValue: Int(base.currency))!
  }

  var targets: [Alfheim.Transaction] {
    return base.targets.map { Array($0) } ?? []
  }

  var sources: [Alfheim.Transaction] {
    return base.sources.map { Array($0) } ?? []
  }

  var children: [Account] {
    return base.children.map { Array($0) } ?? []
  }
}

