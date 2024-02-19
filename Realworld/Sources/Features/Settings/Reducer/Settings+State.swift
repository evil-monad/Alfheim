//
//  Settings+State.swift
//  Settings+State
//
//  Created by alex.huo on 2021/9/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import Kit
import ComposableArchitecture

extension Settings {
  /// Settings view state
  @ObservableState
  public struct State: Equatable {
    var isPresented: Bool = false
    var appIcon: AppIcon = .primary

    var appVersion: String {
      Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }
  }
}
