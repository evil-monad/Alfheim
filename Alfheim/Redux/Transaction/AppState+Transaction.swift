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

    var isLoading = false

    var selectedTransaction: Alfheim.Transaction?
    var editingTransaction: Bool = false

    var searchText = ""

    func displayViewModels(tag: Alne.Tagit) -> [TransactionViewModel] {
      return transactions
        .map { TransactionViewModel(transaction: $0, tag: tag) }
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
