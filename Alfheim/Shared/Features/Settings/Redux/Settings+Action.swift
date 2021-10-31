//
//  Settings+Action.swift
//  Settings+Action
//
//  Created by alex.huo on 2021/9/4.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

extension AppAction {
  enum Settings {
    case sheet(isPresented: Bool)

    case selectAppIcon(AppIcon)
  }
}
