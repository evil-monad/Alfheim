//
//  Piece.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/22.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct Piece: View {
  struct Data: Identifiable {
    var id = UUID()
    var unit: Unit
    var amount: Double
  }

  @State private var fill: Bool = false
  var index: Int
  
  var body: some View {
    Capsule()
      .fill(LinearGradient(gradient: Gradient(colors: [.ah02, .ah03]), startPoint: .bottom, endPoint: .top))
      .scaleEffect(x: 1, y: self.fill ? 1 : 0, anchor: .bottom)
      .onAppear() {
        withAnimation(Animation.spring().delay(Double(self.index) * 0.05)) {
          self.fill = true
        }
    }
  }
}


struct RelativeHeight<S: Shape>: Shape {
  let shape: S
  var relativeHeight: CGFloat
  func path(in rect: CGRect) -> Path {
    let childRect = rect.divided(atDistance: relativeHeight * rect.height, from: .maxYEdge).slice
    return shape.path(in: childRect)
  }
}

extension Shape {
  func relativeHeight(_ height: CGFloat) -> some Shape {
    RelativeHeight(shape: self, relativeHeight: height)
  }
}
