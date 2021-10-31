//
//  Appearance.swift
//  Alfheim
//
//  Created by alex.huo on 2021/10/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class Appearance {
  static let shared = Appearance()
  
  @AppStorage("selectedAppearance") var selectedAppearance = 0
  var userInterfaceStyle: ColorScheme? = .dark

  func overrideDisplayMode() {
    var userInterfaceStyle: UIUserInterfaceStyle

    if selectedAppearance == 2 {
        userInterfaceStyle = .dark
    } else if selectedAppearance == 1 {
        userInterfaceStyle = .light
    } else {
        userInterfaceStyle = .unspecified
    }

    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    scene?.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
  }
}
