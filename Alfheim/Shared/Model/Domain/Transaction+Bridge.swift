//
//  Transaction+CoreData.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Database
import Domain

extension Domain.Transaction {
  init?(_ entity: Database.Transaction) {
    guard let target = entity.target, let source = entity.source else {
      return nil
    }
    let attachments = entity.attachments?.compactMap(Domain.Attachment.init) ?? []
    self.init(
      id: entity.id,
      amount: entity.amount,
      currency: entity.currency,
      date: entity.date,
      notes: entity.notes,
      payee: entity.payee,
      number: entity.number,
      repeated: entity.repeated,
      cleared: entity.cleared,
      flagged: entity.flagged,
      target: Domain.Account.Summary(target),
      source: Domain.Account.Summary(source),
      attachments: attachments
    )
  }
}

extension Database.Transaction {
  func fill(_ model: Domain.Transaction) {
    id = model.id
    amount = model.amount
    currency = model.currency.rawValue
    date = model.date
    notes = model.notes
    payee = model.payee
    number = model.number
    repeated = model.repeated
    cleared = model.cleared
    flagged = model.flagged
  }

  func fill(target: Database.Account) {
    self.target = target
  }

  func fill(source: Database.Account) {
    self.source = source
  }

  func fill(attachments: [Database.Attachment]) {
    self.attachments = Set(attachments)
  }
}

extension Domain.Transaction {
  static func uniqued(_ transactions: [Domain.Transaction]) -> [Domain.Transaction] {
    var uniqueTransactions: [Domain.Transaction] = []
    var filter = Set<UUID>()
    for transaction in transactions {
      if !filter.contains(transaction.id) {
        uniqueTransactions.append(transaction)
        filter.insert(transaction.id)
      }
    }
    return uniqueTransactions
  }
}

// typealias Database.Transaction = Alfheim.Transaction

//final class Transaction: NSManagedObject, Identifiable {
//  class func fetchRequest() -> NSFetchRequest<Transaction> {
//      return NSFetchRequest<Transaction>(entityName: "Transaction")
//  }
//
//  @NSManaged var id: UUID
//  @NSManaged var amount: Double
//  @NSManaged var currency: Int16
//
//  @NSManaged var date: Date
//  @NSManaged var notes: String
//  @NSManaged var payee: String?
//  @NSManaged var number: String?
//
//  @NSManaged var repeated: Int16
//  @NSManaged var cleared: Bool
//  @NSManaged var flagged: Bool
//
//  // relationship
//  @NSManaged var target: Account?
//  @NSManaged var source: Account?
//  @NSManaged var attachments: NSSet?
//}

//extension Transaction {
//  class Snapshot {
//    let transaction: Transaction?
//
//    var id: UUID
//    var amount: Double
//    var currency: Int16
//
//    var date: Date
//    var notes: String
//    var payee: String? = nil
//    var number: String? = nil
//
//    var repeated: Int16
//    var cleared: Bool
//    var flagged: Bool
//
//    var target: Account?
//    var source: Account?
//    var attachments: NSSet?
//
//    init(_ transaction: Transaction) {
//      self.transaction = transaction
//
//      self.id = transaction.id
//      self.amount = transaction.amount
//      self.currency = transaction.currency
//
//      self.date = transaction.date
//      self.notes = transaction.notes
//      self.payee = transaction.payee
//      self.number = transaction.number
//
//      self.repeated = transaction.repeated
//      self.cleared = transaction.cleared
//      self.flagged = transaction.flagged
//
//      self.target = transaction.target
//      self.source = transaction.source
//      self.attachments = transaction.attachments
//    }
//
//    init(amount: Double,
//         currency: Int16,
//         date: Date,
//         notes: String,
//         payee: String? = nil,
//         number: String? = nil,
//         repeated: Int16 = 0,
//         cleared: Bool = true,
//         flagged: Bool = false,
//         target: Account,
//         source: Account,
//         attachments: [Attachment] = []) {
//      self.transaction = nil
//      self.id = UUID()
//      self.amount = amount
//      self.currency = currency
//      self.date = date
//      self.notes = notes
//      self.payee = payee
//      self.number = number
//      self.repeated = repeated
//      self.cleared = cleared
//      self.flagged = flagged
//      self.target = target
//      self.source = source
//      self.attachments = NSSet(object: attachments)
//    }
//  }
//}
//
//extension Alfheim.Transaction {
//  static func object(_ snapshot: Snapshot, context: NSManagedObjectContext) -> Alfheim.Transaction {
//    let object = snapshot.transaction ?? Alfheim.Transaction(context: context)
//    object.fill(snapshot)
//    return object
//  }
//
//  func fill(_ snapshot: Snapshot) {
//    id = snapshot.id
//    amount = snapshot.amount
//    currency = snapshot.currency
//    date = snapshot.date
//    notes = snapshot.notes
//    payee = snapshot.payee
//    number = snapshot.number
//    repeated = snapshot.repeated
//    cleared = snapshot.cleared
//    flagged = snapshot.flagged
//    target = snapshot.target
//    source = snapshot.source
//    //attachments  = snapshot.attachments
//  }
//}
//
//extension Alfheim.Transaction {
//  static func uniqued(_ transactions: [Transaction]) -> [Transaction] {
//    var uniqueTransactions: [Transaction] = []
//    var filter = Set<UUID>()
//    for transaction in transactions {
//      if !filter.contains(transaction.id) {
//        uniqueTransactions.append(transaction)
//        filter.insert(transaction.id)
//      }
//    }
//    return uniqueTransactions
//  }
//}
