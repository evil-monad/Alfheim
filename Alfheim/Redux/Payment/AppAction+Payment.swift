//
//  AppAction+Payment.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppAction {
  enum Payment {
    case updated([Alfheim.Payment])
    case loadPayment(kind: Int)
    case loadPaymentDone(Alfheim.Payment)

    case toggleNewPayment(presenting: Bool)
    case editPayment(Alfheim.Payment)
    case editPaymentDone

    case save(Alfheim.Payment.Snapshot, mode: EditMode)
    case validate(valid: Bool)
    case edit(Alfheim.Payment)
    case new

    case delete(at: IndexSet)
  }
}
