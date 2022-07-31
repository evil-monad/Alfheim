//
//  AppCommand+Payment.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

//extension AppCommands {
//  struct LoadPaymentCommand: AppCommand {
//    let kind: Int
//
//    func execute(in store: AppStore) {
//      let persistence = Persistences.Payment(context: store.context)
//      if let payment = persistence.payment(withKind: kind) {
//        store.dispatch(.payment(.loadPaymentDone(payment)))
//      } else {
//        let token = SubscriptionToken()
//        persistence.fetchPublisher(withKind: kind)
//          .sink(receiveCompletion: { completion in
//            if case .failure(let error) = completion {
//              print("error: \(error)")
//            }
//            token.unseal()
//          }, receiveValue: { payment in
//            store.dispatch(.payment(.loadPaymentDone(payment)))
//          })
//          .seal(in: token)
//      }
//    }
//  }
//
//  struct CreatePaymentCommand: AppCommand {
//    let payment: Alfheim.Payment.Snapshot
//
//    func execute(in store: AppStore) {
//      let persistence = Persistences.Payment(context: store.context)
//      let object = Alfheim.Payment(context: store.context)
//      object.fill(payment)
//
//      do {
//        try persistence.save()
//      } catch {
//        print("Update account failed: \(error)")
//      }
//    }
//  }
//
//  struct UpdatePaymentCommand: AppCommand {
//    let payment: Alfheim.Payment.Snapshot
//
//    func execute(in store: AppStore) {
//      let persistence = Persistences.Payment(context: store.context)
//      if let object = persistence.payment(withID: payment.id) {
//        object.fill(payment)
//      } else {
//        fatalError("Should not be here!")
//      }
//
//      do {
//        try persistence.save()
//      } catch {
//        print("Update transaction failed: \(error)")
//      }
//    }
//  }
//
//  struct DeletePaymentCommand: AppCommand {
//    let payments: [Alfheim.Payment]
//
//    func execute(in store: AppStore) {
//      guard !payments.isEmpty else {
//        return
//      }
//
//      let persistence = Persistences.Payment(context: store.context)
//
//      for payment in payments {
//        delete(payment, persistence: persistence)
//      }
//
//      do {
//        try persistence.save()
//      } catch {
//        print("Delete transaction failed: \(error)")
//      }
//    }
//
//    private func delete(_ payment: Alfheim.Payment, persistence: Persistences.Payment) {
//      guard let object = persistence.payment(withID: payment.id) else {
//        fatalError("Should not be here!")
//      }
//      // object.fill(transaction)
//      persistence.delete(object)
//    }
//  }
//}
