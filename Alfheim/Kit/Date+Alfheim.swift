//
//  Date+Alfheim.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/28.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension Date {
  var startOfWeek: Date {
    return start(of: .week)
  }

  var startOfMonth: Date {
    return start(of: .month)
  }

  var startOfYear: Date {
    return start(of: .year)
  }
}

extension Date {
  enum Component {
    case day
    case week
    case month
    case year
  }

  func interval(of component: Component, calendar: Calendar = .current) -> DateInterval? {
    switch component {
    case .day:
      return calendar.dateInterval(of: .day, for: self)
    case .week:
      return calendar.dateInterval(of: .weekOfYear, for: self)
    case .month:
      return calendar.dateInterval(of: .month, for: self)
    case .year:
      return calendar.dateInterval(of: .year, for: self)
    }
  }

  func start(of component: Component, calendar: Calendar = Calendar.current) -> Date {
    interval(of: component, calendar: calendar)!.start
  }

  func next(of component: Component, calendar: Calendar = .current) -> Date {
    switch component {
    case .day:
      return calendar.date(byAdding: .hour, value: 24, to: self)!
    case .week:
      return calendar.date(byAdding: .day, value: 7, to: self)!
    case .month:
      return calendar.date(byAdding: .month, value: 1, to: self)!
    case .year:
      return calendar.date(byAdding: .year, value: 1, to: self)!
    }
  }

  func end(of component: Component, calendar: Calendar = .current) -> Date {
    interval(of: component, calendar: calendar)!.end
  }
}

extension Date {
  var string: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd HH:mm"
    return formatter.string(from: self)
  }

  var alfheim: String {
    return "\(formatted(.dateTime.day().month().hour().minute()))"
  }
}
