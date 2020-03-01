//
//  Transaction.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/3.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

struct Transaction: Identifiable {
  var id: String { UUID().uuidString }
  var date: Date
  var amount: Double
  var catemoji: Catemoji
  var notes: String
  var currency: Currency = .cny
  var payee: String? = nil
  var number: Int = 0
  var from: Account? = Accounts.income
  var to: Account? = Accounts.expenses
}

enum Currency: Int, CaseIterable {
  case cny
  case hkd
  case jpy
  case usd

  var text: String {
    switch self {
    case .cny: return "CNY"
    case .hkd: return "HKD"
    case .jpy: return "JPY"
    case .usd: return "USD"
    }
  }

  var symbol: String {
    switch self {
    case .cny: return "¥"
    case .hkd: return "$"
    case .jpy: return "¥"
    case .usd: return "$"
    }
  }
}

extension Transaction {
  static func samples() -> [Transaction] {
    return [
      Transaction(date: Date(timeIntervalSince1970: 1582726132.0), amount: 23.0, catemoji: .fruit(.apple), notes: "Apple"),
      Transaction(date: Date(timeIntervalSince1970: 1582720132.0), amount: 123.0, catemoji: .drink(.beer), notes: "Food"),
      Transaction(date: Date(timeIntervalSince1970: 1582624196.0), amount: 13.5, catemoji: .food(.snacks), notes: "Mc"),
      Transaction(date: Date(timeIntervalSince1970: 1582616139.0), amount: 2333.0, catemoji: .transportation(.airplane), notes: "Transportation"),
      Transaction(date: Date(timeIntervalSince1970: 1582531152.0), amount: 17.5, catemoji: .transportation(.taxi), notes: "Texi"),
      Transaction(date: Date(timeIntervalSince1970: 1582526132.0), amount: 77.0, catemoji: .clothes(.thirt), notes: "Clothes"),
      Transaction(date: Date(timeIntervalSince1970: 1582486532.0), amount: 230.0, catemoji: .household(.house), notes: "Household"),
      Transaction(date: Date(timeIntervalSince1970: 1582444232.0), amount: 5.0, catemoji: .personal(.privacy), notes: "Personal"),
      Transaction(date: Date(timeIntervalSince1970: 1582320132.0), amount: 93.0, catemoji: .drink(.beer), notes: "Food"),
      Transaction(date: Date(timeIntervalSince1970: 1582306192.0), amount: 2233.0, catemoji: .household(.travel), notes: "Travel"),
      Transaction(date: Date(timeIntervalSince1970: 1582201232.0), amount: 21.0, catemoji: .fruit(.apple), notes: "Apple"),
    ]
  }
}
