//
//  Importer.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/5/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

/// Import transactions
struct Serializer {
  let directory: URL

  init?() {
    guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.xspyhack.Alfheim") else {
      return nil
    }
    directory = container.appendingPathComponent("shared", isDirectory: true)
  }

  func handle(url: URL) -> Bool {
    guard url.host == "share" else {
      return false
    }
    return true
  }

  func decode() throws -> [[String: Any]] {
    let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)

    return try contents.flatMap {
      try decode(from: $0)
    }
  }

  func clear() throws {
    let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
    for url in contents {
      try FileManager.default.removeItem(at: url)
    }
  }

  func decode(from fileURL: URL) throws -> [[String: Any]] {
    let data = try Data(contentsOf: fileURL)
    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

    if let transactions = json as? [[String: Any]] {
      return transactions
    } else {
      return []
    }
  }
}
