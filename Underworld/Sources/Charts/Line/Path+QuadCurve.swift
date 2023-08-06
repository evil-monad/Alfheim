//
//  Path+QuadCurve.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/20.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

extension Path {
  static func quadCurved(points: [Double],
                         step: CGPoint,
                         padding: CGFloat = 0,
                         closed: Bool = false) -> Path {
    var path = Path()
    guard points.count >= 2 else { return path }

    guard let offset = points.min() else { return path }

    var p1 = CGPoint(x: 0, y: CGFloat(points[0] - offset) * step.y + padding)
    if closed {
      path.move(to: .zero)
      path.addLine(to: p1)
    } else {
      path.move(to: p1)
    }

    for index in 1..<points.count {
      let p2 = CGPoint(x: step.x * CGFloat(index), y: step.y * CGFloat(points[index] - offset) + padding)
      let midPoint = CGPoint.mid(p1: p1, p2: p2)
      path.addQuadCurve(to: midPoint, control: CGPoint.control(p1: midPoint, p2: p1))
      path.addQuadCurve(to: p2, control: CGPoint.control(p1: midPoint, p2: p2))
      p1 = p2
    }

    if closed {
      path.addLine(to: CGPoint(x: p1.x, y: 0))
      path.closeSubpath()
    }

    return path
  }
}

extension Path {
  func trimmedPath(for percent: CGFloat) -> Path {
    let boundsDistance: CGFloat = 0.001
    let completion: CGFloat = 1 - boundsDistance

    let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)

    let start = pct > completion ? completion : pct - boundsDistance
    let end = pct > completion ? 1 : pct + boundsDistance
    return trimmedPath(from: start, to: end)
  }

  func point(at position: CGFloat) -> CGPoint {
    var pos = position.remainder(dividingBy: 1)
    if pos < 0 {
      pos = 1 + pos
    }
    return pos > 0 ? trimmedPath(from: 0, to: position).cgPath.currentPoint : cgPath.currentPoint
  }

  func point(for percent: CGFloat) -> CGPoint {
    let path = trimmedPath(for: percent)
    return CGPoint(x: path.boundingRect.midX, y: path.boundingRect.midY)
  }

  func point(to x: CGFloat) -> CGPoint {
    let total = length
    let sub = length(to: x)
    let percent = sub / total
    let path = trimmedPath(for: percent)
    return CGPoint(x: path.boundingRect.midX, y: path.boundingRect.midY)
  }

  var length: CGFloat {
    var ret: CGFloat = 0.0
    var start: CGPoint?
    var point = CGPoint.zero

    forEach { ele in
      switch ele {
      case .move(let to):
        if start == nil {
          start = to
        }
        point = to
      case .line(let to):
        ret += point.line(to: to)
        point = to
      case .quadCurve(let to, let control):
        ret += point.quadCurve(to: to, control: control)
        point = to
      case .curve(let to, let control1, let control2):
        ret += point.curve(to: to, control1: control1, control2: control2)
        point = to
      case .closeSubpath:
        if let to = start {
          ret += point.line(to: to)
          point = to
        }
        start = nil
      }
    }
    return ret
  }

  func length(to maxX: CGFloat) -> CGFloat {
    var ret: CGFloat = 0.0
    var start: CGPoint?
    var point = CGPoint.zero
    var finished = false

    forEach { ele in
      if finished {
        return
      }
      switch ele {
      case .move(let to):
        if to.x > maxX {
          finished = true
          return
        }
        if start == nil {
          start = to
        }
        point = to
      case .line(let to):
        if to.x > maxX {
          finished = true
          ret += point.line(to: to, x: maxX)
          return
        }
        ret += point.line(to: to)
        point = to
      case .quadCurve(let to, let control):
        if to.x > maxX {
          finished = true
          ret += point.quadCurve(to: to, control: control, x: maxX)
          return
        }
        ret += point.quadCurve(to: to, control: control)
        point = to
      case .curve(let to, let control1, let control2):
        if to.x > maxX {
          finished = true
          ret += point.curve(to: to, control1: control1, control2: control2, x: maxX)
          return
        }
        ret += point.curve(to: to, control1: control1, control2: control2)
        point = to
      case .closeSubpath:
        fatalError("Can't include closeSubpath")
      }
    }
    return ret
  }
}

extension CGPoint {
  func dist(to: CGPoint) -> CGFloat {
    sqrt((pow(self.x - to.x, 2) + pow(self.y - to.y, 2)))
  }

  func point(to: CGPoint, x: CGFloat) -> CGPoint {
    let a = (to.y - self.y) / (to.x - self.x)
    let y = self.y + (x - self.x) * a
    return CGPoint(x: x, y: y)
  }

  func line(to: CGPoint) -> CGFloat {
    dist(to: to)
  }

  func line(to: CGPoint, x: CGFloat) -> CGFloat {
    dist(to: point(to: to, x: x))
  }

  func quadCurve(to: CGPoint, control: CGPoint) -> CGFloat {
    var dist: CGFloat = 0
    let steps: CGFloat = 100

    for i in 0..<Int(steps) {
      let t0 = CGFloat(i) / steps
      let t1 = CGFloat(i+1) / steps
      let a = point(to: to, t: t0, control: control)
      let b = point(to: to, t: t1, control: control)

      dist += a.line(to: b)
    }
    return dist
  }

  func quadCurve(to: CGPoint, control: CGPoint, x: CGFloat) -> CGFloat {
    var dist: CGFloat = 0
    let steps: CGFloat = 100

    for i in 0..<Int(steps) {
      let t0 = CGFloat(i) / steps
      let t1 = CGFloat(i+1) / steps
      let a = point(to: to, t: t0, control: control)
      let b = point(to: to, t: t1, control: control)

      if a.x >= x {
        return dist
      } else if b.x > x {
        dist += a.line(to: b, x: x)
        return dist
      } else if b.x == x {
        dist += a.line(to: b)
        return dist
      }

      dist += a.line(to: b)
    }
    return dist
  }

  func point(to: CGPoint, t: CGFloat, control: CGPoint) -> CGPoint {
    let x = CGPoint.value(x: self.x, y: to.x, t: t, c: control.x)
    let y = CGPoint.value(x: self.y, y: to.y, t: t, c: control.y)

    return CGPoint(x: x, y: y)
  }

  func curve(to: CGPoint, control1: CGPoint, control2: CGPoint) -> CGFloat {
    var dist: CGFloat = 0
    let steps: CGFloat = 100

    for i in 0..<Int(steps) {
      let t0 = CGFloat(i) / steps
      let t1 = CGFloat(i+1) / steps

      let a = point(to: to, t: t0, control1: control1, control2: control2)
      let b = point(to: to, t: t1, control1: control1, control2: control2)

      dist += a.line(to: b)
    }

    return dist
  }

  func curve(to: CGPoint, control1: CGPoint, control2: CGPoint, x: CGFloat) -> CGFloat {
    var dist: CGFloat = 0
    let steps: CGFloat = 100

    for i in 0..<Int(steps) {
      let t0 = CGFloat(i) / steps
      let t1 = CGFloat(i+1) / steps

      let a = point(to: to, t: t0, control1: control1, control2: control2)
      let b = point(to: to, t: t1, control1: control1, control2: control2)

      if a.x >= x {
        return dist
      } else if b.x > x {
        dist += a.line(to: b, x: x)
        return dist
      } else if b.x == x {
        dist += a.line(to: b)
        return dist
      }

      dist += a.line(to: b)
    }

    return dist
  }

  func point(to: CGPoint, t: CGFloat, control1: CGPoint, control2: CGPoint) -> CGPoint {
    let x = CGPoint.value(x: self.x, y: to.x, t: t, c1: control1.x, c2: control2.x)
    let y = CGPoint.value(x: self.y, y: to.y, t: t, c1: control1.y, c2: control2.x)

    return CGPoint(x: x, y: y)

  }

  static func value(x: CGFloat, y: CGFloat, t: CGFloat, c: CGFloat) -> CGFloat {
    var value: CGFloat = 0.0
    // (1-t)^2 * p0 + 2 * (1-t) * t * c1 + t^2 * p1
    value += pow(1-t, 2) * x
    value += 2 * (1-t) * t * c
    value += pow(t, 2) * y
    return value
  }

  static func value(x: CGFloat, y: CGFloat, t: CGFloat, c1: CGFloat, c2: CGFloat) -> CGFloat {
    var value: CGFloat = 0.0
    // (1-t)^3 * p0 + 3 * (1-t)^2 * t * c1 + 3 * (1-t) * t^2 * c2 + t^3 * p1
    value += pow(1-t, 3) * x
    value += 3 * pow(1-t, 2) * t * c1
    value += 3 * (1-t) * pow(t, 2) * c2
    value += pow(t, 3) * y
    return value
  }

  func mid(point: CGPoint) -> CGPoint {
    CGPoint(
      x: (self.x + point.x) / 2,
      y: (self.y + point.y) / 2
    )
  }

  func control(point: CGPoint) -> CGPoint {
    var controlPoint = mid(point: point)
    let diffY = abs(point.y - controlPoint.y)

    if (self.y < point.y) {
      controlPoint.y += diffY
    } else if (self.y > point.y) {
      controlPoint.y -= diffY
    }
    return controlPoint
  }

  static func mid(p1: CGPoint, p2: CGPoint) -> CGPoint {
    p1.mid(point: p2)
  }

  static func control(p1: CGPoint, p2: CGPoint) -> CGPoint {
    p1.control(point: p2)
  }
}
