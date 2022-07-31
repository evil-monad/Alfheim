//
//  AppReducer+Payment.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation

extension AppReducers {
//  enum Payment {
//    static func reduce(state: AppState, action: AppAction.Payment) -> (AppState, AppCommand?) {
//      var appState = state
//      var appCommand: AppCommand? = nil
//
//      switch action {
//      case .updated(let payments):
//        appState.shared.allPayments = payments
//        appState.payment.payments = payments
//        appState.editor.payments = payments
//
//        if !(payments.filter { $0.kind == -1 }).isEmpty {
//          //appState.editor.validator.defaultPayment = payment
//        } else {
//          appCommand = AppCommands.LoadPaymentCommand(kind: -1)
//        }
//      case .loadPayment(let kind):
//        appCommand = AppCommands.LoadPaymentCommand(kind: kind)
//      case .loadPaymentDone(let payment):
//        if payment.kind == -1 {
//          //appState.editor.validator.defaultPayment = payment
//        }
//
//      case .toggleNewPayment(let presenting):
//        appState.payment.isEditorPresented = presenting
//        appState.payment.isValid = false // Important! need set here
//        appState.payment.validator.reset(.new)
//      case .editPayment(let payment):
//        appState.payment.editingPayment = true
//        appState.payment.isValid = true // Important! need set here
//        appState.payment.validator.reset(.edit(payment))
//      case .editPaymentDone:
//        appState.payment.editingPayment = false
//        appState.payment.isValid = false // Important! need set here
//        appState.payment.validator.reset(.new)
//
//      case .save(let snapshot, mode: let mode):
//        appState.editor.validator.reset(.new)
//        switch mode {
//        case .new:
//          appCommand = AppCommands.CreatePaymentCommand(payment: snapshot)
//        case .update:
//          appCommand = AppCommands.UpdatePaymentCommand(payment: snapshot)
//        case .delete:
//          fatalError("Editor can't delete")
//        }
//      case .validate(let valid):
//        appState.payment.isValid = valid
//      case .edit(let payment):
//        appState.payment.validator.reset(.edit(payment))
//      case .new:
//        appState.payment.validator.reset(.new)
//
//      case .delete(at: let indexSet):
//        let payments = state.payment.payments.elements(atOffsets: indexSet)
//        if let id = UserDefaults.standard.string(forKey: "com.alfheim.payment.build-in") {
//          let valids = payments.filter { $0.id.uuidString != id }
//          appCommand = AppCommands.DeletePaymentCommand(payments: valids)
//        } else {
//          appCommand = AppCommands.DeletePaymentCommand(payments: payments)
//        }
//      }
//
//      return (appState, appCommand)
//    }
//  }
}
