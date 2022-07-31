//
//  AppError+Setting.swift
//  Alfheim
//
//  Created by alex.huo on 2020/6/27.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppError {
  enum Settings: Error, Identifiable {
    var id: String { localizedDescription }

    case changeAppIconFalied(Error)
  }
}

extension AppError.Settings: LocalizedError {
  var localizedDescription: String {
    switch self {
    case .changeAppIconFalied(let error):
      return error.localizedDescription
    }
  }
}
