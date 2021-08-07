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
}
