//
//  Line.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/20.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct Line: View {
  @ObservedObject var histogram: Histogram<Dimension>
  @Binding var frame: CGRect
  @Binding var touchLocation: CGPoint
  @Binding var showsIndicator: Bool
  @State private var fill: Bool = false
  @State private var showsBackground: Bool = true
  @State private var padding: CGFloat = 4

  private var stepWidth: CGFloat {
    if histogram.units.count < 2 {
      return 0
    }
    return frame.size.width / CGFloat(histogram.units.count - 1)
  }

  private var stepHeight: CGFloat {
    let points = histogram.points()

    guard let min = points.min(),
      let max = points.max(), min != max else {
      return 0
    }
    return (frame.size.height - padding * 2) / CGFloat(max - min)
  }

  private var step: CGPoint {
    CGPoint(x: stepWidth, y: stepHeight)
  }

  private var path: Path {
    let points = histogram.points()
    return Path.quadCurved(points: points,
                           step: step,
                           padding: padding)
  }

  private var closedPath: Path {
    let points = histogram.points()
    return Path.quadCurved(points: points,
                           step: step,
                           padding: padding,
                           closed: true)
  }

  var body: some View {
    ZStack {
      if fill && showsBackground {
        closedPath
          .fill(LinearGradient(gradient: Gradient(colors: [.ah01, Color(UIColor.secondarySystemGroupedBackground)]), startPoint: .bottom, endPoint: .top))
          .rotationEffect(.degrees(180), anchor: .center)
          .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
          .transition(.opacity)
          .animation(.easeIn(duration: 1.6), value: fill)
      }
      path.trim(from: 0, to: fill ? 1 : 0)
        .stroke(LinearGradient(gradient: Gradient(colors: [.ah02, .ah03]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .animation(.easeOut(duration: 1.2), value: fill)
        .onAppear() {
          fill = true
        }
        .drawingGroup()
      if showsIndicator {
        Indicator()
          .position(closestPoint(point: touchLocation))
          .rotationEffect(.degrees(180), anchor: .center)
          .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
      }
    }
  }
}

extension Line {
  func closestPoint(point: CGPoint) -> CGPoint {
    return path.point(to: point.x)
  }
}

extension Color {
  static let ah00 = Color("AH00")
  static let ah01 = Color("AH01")
  static let ah02 = Color("AH02")
  static let ah03 = Color("AH03")

  static let shadow = Color(.sRGBLinear, white: 0, opacity: 0.23)
}


#if DEBUG
struct Line_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { geometry in
      Line(histogram: Histogram(points: [20, 6, 4, 2, 4, 6, 0]), frame: .constant(geometry.frame(in: .local)), touchLocation: .constant(CGPoint(x: 10, y: 12)), showsIndicator: .constant(true))
    }
    .frame(width: 320, height: 460)
    .environment(\.colorScheme, .dark)
  }
}
#endif
