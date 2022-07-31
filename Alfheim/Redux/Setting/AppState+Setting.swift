//
//  AppState+Setting.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/15.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppState {
  struct Settings {
    var isPaymentEnabled = true

    var appIcon: AppIcon = .primary

    var appVersion: String {
      Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }
  }
}
