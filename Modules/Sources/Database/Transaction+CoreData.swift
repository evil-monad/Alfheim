//
//  Transaction+CoreData.swift
//  Database
//
//  Created by alex.huo on 2020/3/6.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import CoreData

public final class Transaction: NSManagedObject, Identifiable {
  public class func fetchRequest() -> NSFetchRequest<Transaction> {
      return NSFetchRequest<Transaction>(entityName: "Transaction")
  }

  @NSManaged public var id: UUID
  @NSManaged public var amount: Double
  @NSManaged public var currency: Int16

  @NSManaged public var date: Date
  @NSManaged public var notes: String
  @NSManaged public var payee: String?
  @NSManaged public var number: String?

  @NSManaged public var repeated: Int16
  @NSManaged public var cleared: Bool
  @NSManaged public var flagged: Bool

  // relationship
  @NSManaged public var target: Account?
  @NSManaged public var source: Account?
  @NSManaged public var attachments: Set<Attachment>?
}

public extension Transaction {
  class Snapshot {
    let transaction: Transaction?

    public var id: UUID
    public var amount: Double
    var currency: Int16

    var date: Date
    var notes: String
    var payee: String? = nil
    var number: String? = nil

    var repeated: Int16
    var cleared: Bool
    var flagged: Bool

    var target: Account?
    var source: Account?
    var attachments: Set<Attachment>?

    public init(_ transaction: Transaction) {
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
      self.flagged = transaction.flagged

      self.target = transaction.target
      self.source = transaction.source
      self.attachments = transaction.attachments
    }

    public init(amount: Double,
         currency: Int16,
         date: Date,
         notes: String,
         payee: String? = nil,
         number: String? = nil,
         repeated: Int16 = 0,
         cleared: Bool = true,
         flagged: Bool = false,
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
      self.flagged = flagged
      self.target = target
      self.source = source
      self.attachments = Set(attachments)
    }
  }
}

public extension Transaction {
  static func object(_ snapshot: Snapshot, context: NSManagedObjectContext) -> Transaction {
    let object = snapshot.transaction ?? Transaction(context: context)
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
    flagged = snapshot.flagged
    target = snapshot.target
    source = snapshot.source
    //attachments  = snapshot.attachments
  }
}

public extension Transaction {
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
