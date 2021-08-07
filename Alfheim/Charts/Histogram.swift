//
//  UnitData.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

/*
protocol Value {
  var value: Double { get }
}

extension Double: Value {
  var value: Double { self }
}

extension Int: Value {
  var value: Double { Double(self) }
}*/

typealias Value = Double

/// A protocol representing a unit of measure
protocol Unit {
  var symbol: String { get }
  var value: Value { get }
}

/// An struct representing a dimensional unit of measure
struct Dimension: Unit {
  var symbol: String
  var value: Value

  init(symbol: String, value: Double) {
    self.symbol = symbol
    self.value = value
  }

  init(point: Double) {
    self.init(symbol: "", value: point)
  }

  init(_ unit: (String, Double)) {
    self.init(symbol: unit.0, value: unit.1)
  }

  init(_ unit: (String, Int)) {
    self.init(symbol: unit.0, value: Double(unit.1))
  }
}

struct LabeledUnit: Unit {
  var symbol: String
  var value: Value
  var label: String

  init(_ unit: (String, Double, String)) {
    self.init(symbol: unit.0, value: unit.1, label: unit.2)
  }

  init(symbol: String, value: Double, label: String) {
    self.symbol = symbol
    self.value = value
    self.label = label
  }

  init(dimension: Dimension, label: String) {
    self.symbol = dimension.symbol
    self.value = dimension.value
    self.label = label
  }
}

class Histogram<UnitType>: ObservableObject where UnitType: Unit {
  @Published var units: [UnitType] = []

  var isNamed: Bool {
    !units.allSatisfy { $0.symbol.isEmpty }
  }

  func points() -> [Value] {
    units.map { $0.value }
  }

  func values() -> [Value] {
    units.map { $0.value }
  }

  func symbols() -> [String] {
    units.map { $0.symbol }
  }

  init(units: [UnitType]) {
    self.units = units
  }
}

extension Histogram where UnitType == Dimension {
  convenience init(values: [(String, Double)]) {
    self.init(units: values.map { Dimension(symbol: $0, value: $1) })
  }

  convenience init(values: [(String, Int)]) {
    self.init(units: values.map { Dimension($0) })
  }

  convenience init(points: [Double]) {
    self.init(units: points.map { Dimension(point: $0) })
  }
}

typealias HistogramLabeledUnit = (String, Double, String)

extension Histogram where UnitType == LabeledUnit {
  convenience init(values: [(String, Double, String)]) {
    self.init(units: values.map { LabeledUnit($0) })
  }

  convenience init(values: [(String, Int, String)]) {
    self.init(units: values.map { LabeledUnit(symbol: $0, value: Double($1), label: $2) })
  }
}
