//
//  AppState+Catemoji.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppState {
  struct Catemoji {
    var catemojis: [Alne.Catemoji] = []
    var isAlertPresented: Bool = false

    var addError: AppError.Catemoji?
    var deleteError: AppError.Catemoji?

    func categorized() -> [Category: [Alne.Catemoji]] {
      catemojis.grouped(by: { $0.category })
    }
  }
}
