//
//  AppIcon.swift
//  Alfheim
//
//  Created by alex.huo on 2020/6/25.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

public enum AppIcon: String, CaseIterable, Equatable {
  case primary
  case filled
}

extension AppIcon: Identifiable {
  public var id: String {
    return rawValue
  }
}

public extension AppIcon {
  var icon: String {
    switch self {
    case .primary:
      return "AppIcon60x60"
    case .filled:
      return "Filled60x60"
    }
  }

  var name: String {
    switch self {
    case .primary:
      return "Default"
    case .filled:
      return "Filled"
    }
  }

  var alternateIconName: String? {
    switch self {
    case .primary:
      return nil
    case .filled:
      return "Filled"
    }
  }
}
