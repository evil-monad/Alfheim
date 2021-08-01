//
//  Account+Tagit.swift
//  Alfheim
//
//  Created by alex.huo on 2021/7/24.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension Alfheim.Account {
  var tagit: Tagit? {
    tag.flatMap { Tagit(stringLiteral: $0) }
  }
}
