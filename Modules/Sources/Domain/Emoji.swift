//
//  Emoji+CoreData.swift
//  Domain
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

public struct Emoji: Equatable, Identifiable {
  public var id: String { text }
  public var category: String
  public var text: String
}
