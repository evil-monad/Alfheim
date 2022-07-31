//
//  Color+Category.swift
//  Alfheim
//
//  Created by BIGO on 2020/6/16.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
  init(category: Category) {
    switch category {
    case .uncleared:
      self = Color("Grape")
    case .food:
      self = Color("Orange")
    case .drink:
      self = Color("Teal")
    case .fruit:
      self = Color("Red")
    case .clothes:
      self = Color("Blue")
    case .household:
      self = Color("Lime")
    case .personal:
      self = Color("Cyan")
    case .services:
      self = Color("Yellow")
    case .transportation:
      self = Color("Indigo")
    }
  }
}

extension Category {
  var color: Color {
    Color(category: self)
  }
}
