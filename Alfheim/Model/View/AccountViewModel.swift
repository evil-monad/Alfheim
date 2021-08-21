//
//  AccountViewModel.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/1.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

struct AccountViewModel {
  var account: Alne.Account

  var name: String { account.name }
  var description: String { account.description }
  var tag: Tagit { account.tag }
}

extension Alne.Account {
  init(_ object: Alfheim.Account) {
    self.id = object.id.uuidString
    self.name = object.name
    self.description = object.introduction
    self.tag = Tagit(stringLiteral: object.tag)
    self.group = .expenses
    self.emoji = object.emoji ?? ""
    //self.currency = Currency(rawValue: Int(object.currency))!
  }
}

extension Alfheim.Account {
  static func object(_ model: Alne.Account, context: NSManagedObjectContext) -> Alfheim.Account {
    let object = Alfheim.Account(context: context)
    object.fill(model)
    return object
  }

  func fill(_ model: Alne.Account) {
    id = UUID()
    name = model.name
    introduction = model.description
    //currency = Int16(model.currency.rawValue)
    emoji = model.emoji
    tag = model.tag.name
    group = model.group.rawValue // can't update
  }
}
