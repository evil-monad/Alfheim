//
//  CurrencyFormatter.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension NumberFormatter {
  static var currency: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "$"
    return formatter
  }
}
