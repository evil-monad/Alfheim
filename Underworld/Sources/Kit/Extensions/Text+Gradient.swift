//
//  Text+Gradient.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

public extension Text {
  func gradient(_ overlay: LinearGradient) -> some View {
    self.overlay(overlay).mask(self)
  }
}
