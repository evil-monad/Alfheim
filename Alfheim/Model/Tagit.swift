//
//  Tagit.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension Alne {
  enum Tagit: String, CaseIterable {
    case red
    case pink
    case grape
    case violet
    case indigo
    case blue
    case cyan
    case teal
    case green
    case lime
    case yellow
    case orange
    case alfheim = "tint"

    var name: String {
      return rawValue.capitalized
    }
  }
}

extension Tagit: Identifiable {
  var id: String {
    return rawValue
  }
}

extension Tagit {
  init(hex: Int) {
    self.init(stringLiteral: String(format:"#%06X", hex))
  }

  var hexValue: Int {
    Int(hex.dropFirst(), radix: 16)!
  }

  var hexDarkValue: Int {
    Int(hexDark.dropFirst(), radix: 16)!
  }
}

extension Tagit {
  var hex: String {
    switch self {
    case .red:
      return "#E03131"
    case .pink:
      return "#C2255C"
    case .grape:
      return "#CC5DE8"
    case .violet:
      return "#7950F2"
    case .indigo:
      return "#4C6EF5"
    case .blue:
      return "#228BE6"
    case .cyan:
      return "#22B8CF"
    case .teal:
      return "#12B886"
    case .green:
      return "#40C057"
    case .lime:
      return "#94D82D"
    case .yellow:
      return "#FAB005"
    case .orange:
      return "#FD7E14"
    case .alfheim:
      return "#D6336C"
    }
  }

  var hexDark: String {
    switch self {
    case .red:
      return "#FA5252"
    case .pink:
      return "#F783AC"
    case .grape:
      return "#E599F7"
    case .violet:
      return "#B197FC"
    case .indigo:
      return "#91A7FF"
    case .blue:
      return "#74C0FC"
    case .cyan:
      return "#66D9E8"
    case .teal:
      return "#63E6BE"
    case .green:
      return "#69DB7C"
    case .lime:
      return "#C0EB75"
    case .yellow:
      return "#FFE066"
    case .orange:
      return "#FFA94D"
    case .alfheim:
      return "#D6336C"
    }
  }
}

extension Tagit: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    self = Tagit(rawValue: value.lowercased()) ?? .alfheim
  }
}
