//
//  TransactionListViewState.swift
//  Alfheim
//
//  Created by alex.huo on 2020/7/10.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

struct TransactionListViewState {
  let transactions: [Transactions.ViewState]
  let filterDate: Date
  let tag: Alne.Tagit
  let currency: Currency
  let displayAmount: Double

  static let yearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter
  }()

  static let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter
  }()

  var selectedYear: String {
    TransactionListViewState.yearFormatter.string(from: filterDate)
  }
  
  var selectedMonth: String {
    TransactionListViewState.monthFormatter.string(from: filterDate)
  }

  var displayAmountText: String {
    displayAmount.formatted(.currency(code: currency.code))
  }

  init(transactions: [Alfheim.Transaction],
       tag: Alne.Tagit,
       currency: Currency,
       filterDate: Date) {
    self.filterDate = filterDate
    self.tag = tag
    self.currency = currency
    self.transactions = transactions.map { Transactions.ViewState(transaction: $0, tag: tag) }
    self.displayAmount = transactions.map { $0.amount }.reduce(0.0, +)
  }
}
