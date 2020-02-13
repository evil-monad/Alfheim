//
//  AppCommand.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

protocol AppCommand {
  func execute(in store: AppStore)
}
