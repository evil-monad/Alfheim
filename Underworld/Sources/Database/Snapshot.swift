//
//  Snapshot.swift
//  Database
//
//  Created by alex.huo on 2021/8/15.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import Foundation

@dynamicMemberLookup
public class Snapshot<Object> {
  public private(set) var original: Object

  public init(object: Object) {
    self.original = object
  }

  public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Object, Subject>) -> Subject {
    get { original[keyPath: keyPath] }
    set { original[keyPath: keyPath] = newValue }
  }
}
