//
//  AppCommnad+Setting.swift
//  Alfheim
//
//  Created by alex.huo on 2020/6/25.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import UIKit

extension AppCommands {
  struct ChangeAppIconCommand: AppCommand {
    let currentIcon: AppIcon
    let selectedIcon: AppIcon

    func execute(in store: AppStore) {
      UIApplication.shared.setAlternateIconName(selectedIcon.alternateIconName) { error in
        if let error = error {
          store.dispatch(.settings(.selectIconDone(self.currentIcon, .failure(AppError.Settings.changeAppIconFalied(error)))))
        } else {
          store.dispatch(.settings(.selectIconDone(self.currentIcon, .success(()))))
        }
      }
    }
  }
}
