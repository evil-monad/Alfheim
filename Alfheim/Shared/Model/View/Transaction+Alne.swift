//
//  Transaction+Alne.swift
//  Transaction+Alne
//
//  Created by alex.huo on 2021/8/1.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension AlneWorld where Base: Alfheim.Transaction {
  var attachments: [Attachment] {
    return base.attachments?.array() ?? []
  }

  var uncleared: Bool {
    !base.cleared
  }

  var repeating: Bool {
    base.repeated > 0
  }

  var flagged: Bool {
    return true
  }
}
