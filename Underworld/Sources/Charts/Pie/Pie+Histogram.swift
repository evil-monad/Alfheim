//
//  Pie+Histogram.swift
//  Alfheim
//
//  Created by alex.huo on 2021/8/8.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation
import SwiftUI

public struct PieUnit: Unit {
  public var label: String
  public var symbol: String
  public var value: Value
  public let color: Color

  public init(label: String, value: Double, symbol: String, color: Color) {
    self.label = label
    self.value = value
    self.symbol = symbol
    self.color = color
  }

  public init(dimension: Dimension, label: String, color: Color) {
    self.symbol = dimension.symbol
    self.value = dimension.value
    self.label = label
    self.color = color
  }
}

public extension Histogram where UnitType == PieUnit {
  convenience init(values: [(String, Double, String, Color)]) {
    self.init(units: values.map { PieUnit(label: $0, value: $1, symbol: $2, color: $3) })
  }

  convenience init(values: [(String, Int, String, Color)]) {
    self.init(units: values.map { PieUnit(label: $0, value: Double($1), symbol: $2, color: $3) })
  }
}
