//
//  AppEnvironment.swift
//  Alfheim
//
//  Created by alex.huo on 2021/2/6.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

struct AppState: Equatable {
  var overviews: [Overview] = []
  //var editor = Editor()
}

extension AppState {
  var accounts: [Alfheim.Account] {
    overviews.map { $0.account }
  }
}
