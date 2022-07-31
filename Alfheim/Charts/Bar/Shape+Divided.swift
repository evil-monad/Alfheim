//
//  Shape+Divided.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/26.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

extension Shape {
  func divided(amount: CGFloat) -> Divided<Self> {
    return Divided(amount: amount, shape: self)
  }
}

struct Divided<S: Shape>: Shape {
  var amount: CGFloat // Should be in range 0...1
  var shape: S
  func path(in rect: CGRect) -> Path {
    shape.path(in: rect.divided(atDistance: amount * rect.height, from: .maxYEdge).slice)
  }
}
