//
//  AppState+Transaction.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/12.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData
import Combine

extension AppState {
  /// Transaction list view state
  struct TransactionList {
    var transactions: [Alfheim.Transaction] = []

    var filterDate = Date()
    var displayTransactions: [Alfheim.Transaction] {
      // current month transactions
      transactions.filter {
        $0.date >= filterDate.start(of: .month) && $0.date < filterDate.next(of: .month).start(of: .month)
      }
    }

    var isLoading = false
    var currency: Currency = .cny

    var selectedTransaction: Alfheim.Transaction?
    var editingTransaction: Bool = false

    var searchText = ""

    var showDatePicker = false
    var selectedDate = Date() // for select
    var dateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMMM, yyyy"
      return formatter
    }
    var pickedDateText: String {
      dateFormatter.string(from: selectedDate)
    }

    var yearFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy"
      return formatter
    }

    var selectedYear: String {
      yearFormatter.string(from: filterDate)
    }

    var monthFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMMM"
      return formatter
    }

    var selectedMonth: String {
      monthFormatter.string(from: filterDate)
    }

    func displayViewModels(tag: Alne.Tagit) -> [TransactionViewModel] {
      return displayTransactions
        .map { TransactionViewModel(transaction: $0, tag: tag) }
    }

    var displayAmount: Double {
      displayTransactions
        .map { $0.amount }
        .reduce(0.0, +)
    }

    var displayAmountText: String {
      "\(currency.symbol)\(String(format: "%.2f", displayAmount))"
    }

    func displayTransactions(from start: Date, to end: Date, tag: Alne.Tagit) -> [TransactionViewModel] {
      return transactions
        .sorted(by: { $0.date > $1.date })
        .filter { $0.date <= end && $0.date >= start }
        .map { TransactionViewModel(transaction: $0, tag: tag) }
    }

    final class Loader {
      @Published var from: Date = Date()
      @Published var to: Date = Date()

      var filter: AnyPublisher<(Date, Date), Never> {
        Publishers.Zip($from, $to).eraseToAnyPublisher()
      }

      var token = SubscriptionToken()
    }

    var loader = Loader()
  }
}
