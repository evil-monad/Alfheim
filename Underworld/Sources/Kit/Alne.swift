//
//  Alne.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

final class AlneWorld<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol ALO {
    associatedtype BaseType

    var alne: AlneWorld<BaseType> { get }
    static var alne: AlneWorld<BaseType>.Type { get }
}

extension ALO {
    var alne: AlneWorld<Self> {
        return AlneWorld(self)
    }

    static var alne: AlneWorld<Self>.Type {
        return AlneWorld<Self>.self
    }
}

extension NSObject: ALO {}
