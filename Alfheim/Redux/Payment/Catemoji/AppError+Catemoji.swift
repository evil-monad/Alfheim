//
//  AppError+Catemoji.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/5.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppError {
  enum Catemoji: Error, Identifiable {
    var id: String { localizedDescription }

    case alreadyExists
    case addFailed(Error)
    case deleteFailed(Error)
  }
}

extension AppError.Catemoji: LocalizedError {
  var localizedDescription: String {
    switch self {
    case .alreadyExists:
      return "Already exists!"
    case .addFailed(let error):
      return error.localizedDescription
    case .deleteFailed(let error):
      return error.localizedDescription
    }
  }
}
