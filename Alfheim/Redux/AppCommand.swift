//
//  AppCommand.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine

//protocol AppCommand {
//  func execute(in store: AppStore)
//}
//
//enum AppCommands {
//}
//
//class SubscriptionToken {
//  var cancellable: AnyCancellable?
//  func unseal() { cancellable = nil }
//}
//
//extension AnyCancellable {
//  func seal(in token: SubscriptionToken) {
//    token.cancellable = self
//  }
//}
//
//extension AppCommands {
//  struct ImportTransactionsCommand: AppCommand {
//    func execute(in store: AppStore) {
//      guard let serializer = Serializer() else {
//        return
//      }
//
//      do {
//        let transactions = try serializer.decode()
//        for transaction in transactions {
//          //let id = transaction["id"] as? String
//          let date = transaction["date"] as? Double ?? 0.0
//          let amount = transaction["amount"] as? Double ?? 0
//          let notes = transaction["notes"] as? String ?? ""
//          let currency = transaction["currency"] as? Int ?? 0
//          //let payment = transaction["payment"] as? String ?? ""
//
//          let obj = Transaction(context: store.context)
//          obj.id = UUID()
//          obj.date = Date(timeIntervalSinceReferenceDate: date)
//          obj.amount = amount
//          obj.notes = notes
//          obj.currency = Int16(currency)
//          obj.category = "uncleared"
//          obj.emoji = "💰"
//        }
//        try store.context.save()
//      } catch {
//        print("decode failed: \(error)")
//      }
//
//      try? serializer.clear()
//
//      store.dispatch(.finishImport)
//    }
//  }
//}
