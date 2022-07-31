//
//  QuadCurve.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct QuadCurved: View {
  var path: Path {
    let points: [Double] = [7, 6, 4, 2, 4, 6, 0]
    return Path.quadCurved(points: points,
                           step: CGPoint(x: 60.0, y: 20.0))
  }

  var subpath: Path {
    let p: CGFloat = 0.5
    return path.trimmedPath(from: 0, to: p)
  }

  @State private var percentage: CGFloat = .zero

  var body: some View {
    ZStack {
      path.trim(from: 0, to: percentage)
        .stroke(LinearGradient(gradient: Gradient(colors: [.ah02, .ah03]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3))
        .rotationEffect(.degrees(180), anchor: .center)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .onAppear() {
          withAnimation(.easeOut(duration: 1.2)) {
            percentage = 1.0
          }
        }
        .drawingGroup()

      subpath.trim(from: 0, to: percentage)
        .stroke(LinearGradient(gradient: Gradient(colors: [.red, .red]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3))
        .rotationEffect(.degrees(180), anchor: .center)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .onAppear() {
            withAnimation(.easeOut(duration: 1.2)) {
              percentage = 1.0
            }
        }
        .drawingGroup()
    }
  }
}

#if DEBUG
struct QuadCurved_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { geometry in
      QuadCurved()
    }
    .frame(width: 360, height: 400)
  }
}
#endif
