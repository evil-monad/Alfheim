//
//  File.swift
//  Domain
//
//  Created by alex.huo on 2021/11/13.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

public enum Currency: Int16, CaseIterable {
  case cny
  case hkd
  case jpy
  case usd
  case eur

  public var text: String {
    code.uppercased()
  }

  public var symbol: String {
    switch self {
    case .cny: return "¥"
    case .hkd: return "$"
    case .jpy: return "¥"
    case .usd: return "$"
    case .eur: return "€"
    }
  }

  public var code: String {
    switch self {
    case .cny: return "CNY"
    case .hkd: return "HKD"
    case .jpy: return "JPY"
    case .usd: return "USD"
    case .eur: return "EUR"
    }
  }
}
