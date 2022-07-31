//
//  Payment.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/24.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension Alne {
  struct Payment {
    var name: String
    var kind: Kind

    enum Kind: Int, CaseIterable {
      case uncleared = -1
      case cash
      case debit
      case credit

      var name: String {
        switch self {
        case .cash:
          return "Cash"
        case .debit:
          return "Debit"
        case .credit:
          return "Credit"
        case .uncleared:
          return "Uncleared"
        }
      }

      var fullname: String {
        switch self {
        case .cash:
          return "Cash"
        case .debit:
          return "Debit Card"
        case .credit:
          return "Credit Card"
        case .uncleared:
          return "Uncleared"
        }
      }
    }
  }
}

extension Alne.Payment: Hashable {}

extension Alne.Payment {
  static let uncleared = Alne.Payment(name: "Uncleared", kind: .uncleared)
}
