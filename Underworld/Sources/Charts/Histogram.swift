//
//  UnitData.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import SwiftUI

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

public typealias Value = Double

/// A protocol representing a unit of measure
public protocol Unit {
  var symbol: String { get }
  var value: Value { get }
}

/// An struct representing a dimensional unit of measure
public struct Dimension: Unit {
  public var symbol: String
  public var value: Value

  public init(symbol: String, value: Double) {
    self.symbol = symbol
    self.value = value
  }

  public init(point: Double) {
    self.init(symbol: "", value: point)
  }

  public init(_ unit: (String, Double)) {
    self.init(symbol: unit.0, value: unit.1)
  }

  public init(_ unit: (String, Int)) {
    self.init(symbol: unit.0, value: Double(unit.1))
  }
}

public struct LabeledUnit: Unit {
  public var symbol: String
  public var value: Value
  public var label: String

  public init(_ unit: (String, Double, String)) {
    self.init(symbol: unit.0, value: unit.1, label: unit.2)
  }

  public init(symbol: String, value: Double, label: String) {
    self.symbol = symbol
    self.value = value
    self.label = label
  }

  public init(dimension: Dimension, label: String) {
    self.symbol = dimension.symbol
    self.value = dimension.value
    self.label = label
  }
}

public class Histogram<UnitType>: ObservableObject where UnitType: Unit {
  @Published var units: [UnitType] = []

  public var isNamed: Bool {
    !units.allSatisfy { $0.symbol.isEmpty }
  }

  public func points() -> [Value] {
    units.map { $0.value }
  }

  public func values() -> [Value] {
    units.map { $0.value }
  }

  public func symbols() -> [String] {
    units.map { $0.symbol }
  }

  public init(units: [UnitType]) {
    self.units = units
  }
}

public extension Histogram where UnitType == Dimension {
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

public typealias HistogramLabeledUnit = (String, Double, String)

public extension Histogram where UnitType == LabeledUnit {
  convenience init(values: [(String, Double, String)]) {
    self.init(units: values.map { LabeledUnit($0) })
  }

  convenience init(values: [(String, Int, String)]) {
    self.init(units: values.map { LabeledUnit(symbol: $0, value: Double($1), label: $2) })
  }
}
