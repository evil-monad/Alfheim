//
//  Color+Tagit.swift
//  Alfheim
//
//  Created by alex.huo on 2020/2/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

extension Color {
  init(hex: Int, alpha: Double = 1) {
    let red = Double((hex & 0xFF0000) >> 16) / 255.0
    let green = Double((hex & 0xFF00) >> 8) / 255.0
    let blue = Double((hex & 0xFF) >> 0) / 255.0
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }
}

/*
extension Color {
  init(tagit: Tagit) {
    self.init(hex: tagit.hexValue)
  }

  init(_ tag: Tagit) {
    self.init(hex: tag.hexValue)
  }
}
*/

extension Color {
  init(tagit: Tagit) {
    self.init(tagit.name)
  }
}

extension Tagit {
  var color: Color {
    Color(tagit: self)
  }
}

extension Color {
  init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0
    var red: Double = 0.0
    var green: Double = 0.0
    var blue: Double = 0.0
    var opacity: Double = 1.0
    let length = hexSanitized.count

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

    if length == 6 {
        red = Double((rgb & 0xFF0000) >> 16) / 255.0
        green = Double((rgb & 0x00FF00) >> 8) / 255.0
        blue = Double(rgb & 0x0000FF) / 255.0
    } else if length == 8 {
        red = Double((rgb & 0xFF000000) >> 24) / 255.0
        green = Double((rgb & 0x00FF0000) >> 16) / 255.0
        blue = Double((rgb & 0x0000FF00) >> 8) / 255.0
        opacity = Double(rgb & 0x000000FF) / 255.0
    } else {
        return nil
    }

    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
}
