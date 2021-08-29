//
//  Transaction+CoreData.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

// typealias Database.Transaction = Alfheim.Transaction

final class Transaction: NSManagedObject, Identifiable {
  class func fetchRequest() -> NSFetchRequest<Transaction> {
      return NSFetchRequest<Transaction>(entityName: "Transaction")
  }

  @NSManaged var id: UUID
  @NSManaged var amount: Double
  @NSManaged var currency: Int16

  @NSManaged var date: Date
  @NSManaged var notes: String
  @NSManaged var payee: String?
  @NSManaged var number: String?

  @NSManaged var repeated: Int16
  @NSManaged var cleared: Bool

  // relationship
  @NSManaged var target: Account?
  @NSManaged var source: Account?
  @NSManaged var attachments: NSSet?
}

extension Transaction {
  var postings: [Account] {
    return []// [target, source]
  }
}

// for ui
extension Transaction {

}

extension Transaction: Duplicatable {
  /// Just like Equatable `==` method
  static func duplicated(lhs: Transaction, rhs: Transaction) -> Bool {
    guard lhs.id == rhs.id,
      lhs.date == rhs.date,
      lhs.amount == rhs.amount,
      lhs.notes == rhs.notes,
      lhs.currency == rhs.currency,
      lhs.payee == rhs.payee,
      lhs.number == rhs.number,
      lhs.target == rhs.target,
      lhs.source == rhs.source,
      lhs.attachments == rhs.attachments
    else {
      return false
    }
    return true
  }
}


extension Array where Element: Alfheim.Transaction {
  static func duplicated(lhs: Self, rhs: Self) -> Bool {
    guard lhs.count == rhs.count else {
      return false
    }

    for (l, r) in zip(lhs, rhs) {
      if !Transaction.duplicated(lhs: l, rhs: r) {
        return false
      }
    }
    return true
  }
}

extension Transaction {
  class Snapshot {
    let transaction: Transaction?

    var id: UUID
    var amount: Double
    var currency: Int16

    var date: Date
    var notes: String
    var payee: String? = nil
    var number: String? = nil

    var repeated: Int16
    var cleared: Bool

    var target: Account?
    var source: Account?
    var attachments: NSSet?

    init(_ transaction: Transaction) {
      self.transaction = transaction

      self.id = transaction.id
      self.amount = transaction.amount
      self.currency = transaction.currency

      self.date = transaction.date
      self.notes = transaction.notes
      self.payee = transaction.payee
      self.number = transaction.number

      self.repeated = transaction.repeated
      self.cleared = transaction.cleared

      self.target = transaction.target
      self.source = transaction.source
      self.attachments = transaction.attachments
    }

    init(amount: Double,
         currency: Int16,
         date: Date,
         notes: String,
         payee: String? = nil,
         number: String? = nil,
         repeated: Int16 = 0,
         cleared: Bool = true,
         target: Account,
         source: Account,
         attachments: [Attachment] = []) {
      self.transaction = nil
      self.id = UUID()
      self.amount = amount
      self.currency = currency
      self.date = date
      self.notes = notes
      self.payee = payee
      self.number = number
      self.repeated = repeated
      self.cleared = cleared
      self.target = target
      self.source = source
      self.attachments = NSSet(object: attachments)
    }
  }
}

extension Alfheim.Transaction {
  static func object(_ snapshot: Snapshot, context: NSManagedObjectContext) -> Alfheim.Transaction {
    let object = snapshot.transaction ?? Alfheim.Transaction(context: context)
    object.fill(snapshot)
    return object
  }

  func fill(_ snapshot: Snapshot) {
    id = snapshot.id
    amount = snapshot.amount
    currency = snapshot.currency
    date = snapshot.date
    notes = snapshot.notes
    payee = snapshot.payee
    number = snapshot.number
    repeated = snapshot.repeated
    cleared = snapshot.cleared
    target = snapshot.target
    source = snapshot.source
    //attachments  = snapshot.attachments
  }
}

extension Alfheim.Transaction {
  static func uniqued(_ transactions: [Transaction]) -> [Transaction] {
    var uniqueTransactions: [Transaction] = []
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
