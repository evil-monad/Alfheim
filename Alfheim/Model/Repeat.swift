//
//  Repeat.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/3.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

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
