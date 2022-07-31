//
//  AppState+Statistics.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/6/8.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppState {
  /// Statistics view state
  struct Statistics {
    var account: Alne.Account
    var period: Period = .monthly
    var timeRange: DateInterval = DateInterval() // Half-Open range, defaults empty range
    var closedTimeRange: DateInterval {
      let upper = timeRange.end.addingTimeInterval(-0.01)
      return DateInterval(start: timeRange.start, end: upper)
    }

    var transactions: [Alfheim.Transaction] = []

    static let day: TimeInterval = 24 * 60 * 60
    static let week: TimeInterval = 7 * day
    static let month: TimeInterval = 30 * day

    var preferPeriod: Period {
      switch period {
      case .weekly:
        return .weekly
      case .monthly:
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if timeRange.contains(today) {
          // this month
          let start = Date().start(of: .month)
          let interval = -start.timeIntervalSinceNow
          // 3 weeks
          if interval < 3 * AppState.Statistics.week {
            return .weekly
          } else {
            return .monthly
          }
        } else {
          return .monthly
        }
      case .yearly:
        let start = Date().start(of: .year)
        let interval = -start.timeIntervalSinceNow
        // 3 weeks
        if interval < 4 * AppState.Statistics.month {
          return .monthly
        } else {
          return .yearly
        }
      }
    }

    var displayTransactions: [TransactionViewModel] {
      transactions
        .map { TransactionViewModel(transaction: $0, tag: account.tag) }
    }

    var categorizedTransactions: [(String, String, Double)] {
      categorized
        .map { category, viewModels in
          (category, viewModels.first!.catemoji.emoji, viewModels.reduce(0.0, { $0 + $1.amount }))
        }
    }

    var categorized: [String: [TransactionViewModel]] {
      displayTransactions
        .grouped { $0.catemoji.category.name }
    }

    var categorizedAmount: [String: Double] {
      displayTransactions
        .grouped { $0.catemoji.category.name }
        .mapValues { $0.reduce(0, { $0 + $1.amount }) }
    }

    func title(with period: Period) -> String {
      switch period {
      case .weekly:
        return "Daily"
      case .monthly:
        return "Weekly"
      case .yearly:
        return "Monthly"
      }
    }

    func labeledAmount(with period: Period) -> [(String, Double)] {
      let calendar = Calendar.current
      let today = calendar.startOfDay(for: Date())

      switch period {
      case .weekly:
        let intervals: TimeInterval = 24 * 60 * 60
        let from = calendar.date(byAdding: .day, value: -6, to: today)!
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let upper = closedTimeRange.end
        let to: Date = min(upper, Date())
        
        return stride(from: from, to: to, by: intervals)
          .map { date -> (String, Double) in
            let label = formatter.string(from: date)
            let next = date.addingTimeInterval(intervals)
            let amount = transactions.filter {
              $0.date >= date && $0.date < next
            }
            .reduce(0, { $0 + $1.amount })
            return (label, amount)
          }

      case .monthly:
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMMMdd"
        var result = [(String, Double)]()
        let upper = closedTimeRange.end
        let to: Date = min(upper, Date())

        for idx in (0..<7).reversed() {
          let week = calendar.date(byAdding: .weekOfYear, value: -idx, to: to)!
          let start = week.start(of: .week)
          let end = week.end(of: .week)
          if !timeRange.contains(end) {
            continue
          }

          let label = formatter.string(from: week)
          let amount = transactions.filter {
            $0.date >= start && $0.date < end
          }
          .reduce(0, { $0 + $1.amount })
          result.append((label, amount))
        }

        return result
      case .yearly:
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        var result = [(String, Double)]()
        for idx in (0..<7).reversed() {
          let month = calendar.date(byAdding: .month, value: -idx, to: Date())!
          let start = month.start(of: .month)
          let end = month.end(of: .month)

          let label = formatter.string(from: month)
          let amount = transactions.filter {
            $0.date >= start && $0.date < end
          }
          .reduce(0, { $0 + $1.amount })
          result.append((label, amount))
        }
        return result
      }
    }
  }
}
