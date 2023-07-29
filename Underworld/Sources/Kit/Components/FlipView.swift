//
//  FlipView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/1/17.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

public struct FlipView<Front: View, Back: View>: View {
  var visibleSide: FlipViewSide
  var front: Front
  var back: Back

  public init(visibleSide: FlipViewSide = .front, @ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back) {
    self.visibleSide = visibleSide
    self.front = front()
    self.back = back()
  }

  public var body: some View {
    ZStack {
      front
        .modifier(FlipModifier(side: .front, visibleSide: visibleSide))
      back
        .modifier(FlipModifier(side: .back, visibleSide: visibleSide))
    }
  }
}

public enum FlipViewSide {
  case front
  case back

  mutating func toggle() {
    self = self == .front ? .back : .front
  }
}

struct FlipModifier: AnimatableModifier {
  var side: FlipViewSide
  var flipProgress: Double

  init(side: FlipViewSide, visibleSide: FlipViewSide) {
    self.side = side
    self.flipProgress = visibleSide == .front ? 0 : 1
  }

  public var animatableData: Double {
    get { flipProgress }
    set { flipProgress = newValue }
  }

  var visible: Bool {
    switch side {
    case .front:
      return flipProgress <= 0.5
    case .back:
      return flipProgress > 0.5
    }
  }

  public func body(content: Content) -> some View {
    ZStack {
      content
        .opacity(visible ? 1 : 0)
        .accessibility(hidden: !visible)
    }
    .scaleEffect(x: scale, y: 1.0)
    .rotation3DEffect(.degrees(flipProgress * -180), axis: (x: 0.0, y: 1.0, z: 0.0), perspective: 0.5)
  }

  var scale: CGFloat {
    switch side {
    case .front:
      return 1.0
    case .back:
      return -1.0
    }
  }
}
