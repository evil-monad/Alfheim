//
//  Sector.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/22.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct Sector: Shape {
  var startDegrees: Double
  var endDegrees: Double

  func path(in rect: CGRect) -> Path {
    Path { path in
      path.addArc(center: rect.mid,
                  radius: rect.radius,
                  startAngle: Angle(degrees: startDegrees),
                  endAngle: Angle(degrees: endDegrees),
                  clockwise: false)
      path.addLine(to: rect.mid)
      path.closeSubpath()
    }
  }
}

extension CGRect {
  var mid: CGPoint {
    CGPoint(x: midX, y: midY)
  }

  var radius: CGFloat {
    min(width, height)/2
  }
}

#if DEBUG
struct Sector_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { geometry in
      Sector(startDegrees: 0.0, endDegrees: 60.0)
    }
    .frame(width: 200, height: 200)
  }
}
#endif
