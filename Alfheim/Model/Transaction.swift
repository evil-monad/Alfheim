//
//  Transaction.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/3.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

//extension Alne {
//  struct Transaction: Identifiable {
//    let id: String
//    var date: Date
//    var amount: Double
//    var catemoji: Alne.Catemoji
//    var notes: String
//    var currency: Currency = .cny
//    /// payment method
//    var payment: Alne.Payment = Payment.uncleared
//    var payee: String? = nil
//    var number: Int = 0
//    /// account
//    var from: Account? = Accounts.income
//    var to: Account? = Accounts.expenses
//  }
//}
//
//extension Alne.Transaction {
//  init(id: String = UUID().uuidString,
//       date: Date,
//       amount: Double,
//       catemoji: Catemoji,
//       notes: String,
//       currency: Currency = .cny,
//       payment: Alne.Payment = Alne.Payment.uncleared) {
//    self.id = id
//    self.date = date
//    self.amount = amount
//    self.catemoji = catemoji
//    self.notes = notes
//    self.currency = currency
//    self.payment = payment
//  }
//}
//
//extension Alne.Transaction: Hashable {}
//
//extension Alne {
//  enum Currency: Int, CaseIterable {
//    case cny
//    case hkd
//    case jpy
//    case usd
//    case eur
//
//    var text: String {
//      code.uppercased()
//    }
//
//    var symbol: String {
//      switch self {
//      case .cny: return "¥"
//      case .hkd: return "$"
//      case .jpy: return "¥"
//      case .usd: return "$"
//      case .eur: return "€"
//      }
//    }
//
//    var code: String {
//      switch self {
//      case .cny: return "CNY"
//      case .hkd: return "HKD"
//      case .jpy: return "JPY"
//      case .usd: return "USD"
//      case .eur: return "EUR"
//      }
//    }
//  }
//}

//extension Alne {
//  enum Transactions {
//    static func samples() -> [Transaction] {
//      return [
//        Transaction(date: Date(timeIntervalSince1970: 1582726132.0), amount: 23.0, catemoji: Catemoji(fruit: .apple), notes: "Apple", currency: .usd),
//        Transaction(date: Date(timeIntervalSince1970: 1582720132.0), amount: 123.0, catemoji: Catemoji(food: .snacks), notes: "Food"),
//        Transaction(date: Date(timeIntervalSince1970: 1582624196.0), amount: 13.5, catemoji: Catemoji(food: .eating), notes: "Mc"),
//        Transaction(date: Date(timeIntervalSince1970: 1582616139.0), amount: 2333.0, catemoji: Catemoji(transportation: .airplane), notes: "Transportation"),
//        Transaction(date: Date(timeIntervalSince1970: 1582531152.0), amount: 17.5, catemoji: Catemoji(transportation: .taxi), notes: "Taxi"),
//        Transaction(date: Date(timeIntervalSince1970: 1582526132.0), amount: 77.0, catemoji: Catemoji(clothes: .shirt), notes: "Clothes"),
//        Transaction(date: Date(timeIntervalSince1970: 1582486532.0), amount: 230.0, catemoji: Catemoji(household: .goods), notes: "Household"),
//        Transaction(date: Date(timeIntervalSince1970: 1582444232.0), amount: 5.0, catemoji: Catemoji(personal: .health), notes: "Personal"),
//      ]
//    }
//  }
//}
//
//extension Alne.Catemoji {
//  init(food: Alne.Food) {
//    self.category = .food
//    self.emoji = food.emoji
//  }
//
//  init(fruit: Alne.Fruit) {
//    self.category = .fruit
//    self.emoji = fruit.emoji
//  }
//
//  init(clothes: Alne.Clothes) {
//    self.category = .clothes
//    self.emoji = clothes.emoji
//  }
//
//  init(transportation: Alne.Transportation) {
//    self.category = .transportation
//    self.emoji = transportation.emoji
//  }
//
//  init(household: Alne.Household) {
//    self.category = .household
//    self.emoji = household.emoji
//  }
//
//  init(personal: Alne.Personal) {
//    self.category = .personal
//    self.emoji = personal.emoji
//  }
//
//  init(uncleared: Alne.Uncleared) {
//    self.category = .uncleared
//    self.emoji = uncleared.emoji
//  }
//}

extension Alne {
  enum Repeat: Int, CaseIterable {
    case never = 0
    case day
    case week
    case month
    case year

    var name: String {
      switch self {
      case .never:
        return "Never"
      case .day:
        return "Day"
      case .week:
        return "Week"
      case .month:
        return "Month"
      case .year:
        return "Year"
      }
    }
  }
}
