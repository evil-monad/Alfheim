//
//  Attachment.swift
//  Domain
//
//  Created by alex.huo on 2021/1/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

public struct Attachment: Equatable, Identifiable {
  public let id: UUID
  public var thumbnail: URL
  public var url: URL
  // relationship
  public var transaction: Transaction.Summary?

  public init(
    id: UUID,
    thumbnail: URL,
    url: URL,
    transaction: Transaction.Summary?
  ) {
    self.id = id
    self.thumbnail = thumbnail
    self.url = url
    self.transaction = transaction
  }
}

extension Attachment: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
