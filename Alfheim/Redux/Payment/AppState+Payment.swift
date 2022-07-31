//
//  AppState+Payment.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/11.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import Foundation
import Combine

extension AppState {
  /// Payment  state
  struct Payment {
    var payments: [Alfheim.Payment] = []
    var isEditorPresented: Bool = false
    var editingPayment: Bool = false

    func displayViewModels(tag: Alne.Tagit) -> [PaymentViewModel] {
      return payments
        .map { PaymentViewModel(payment: $0, tag: tag) }
    }

    enum Mode {
      case new
      case edit(Alfheim.Payment)

      var isNew: Bool {
        switch self {
        case .new:
          return true
        default:
          return false
        }
      }
    }

    class Validator {
      @Published var name: String = ""
      @Published var description: String = ""
      @Published var kind: Alne.Payment.Kind = .uncleared

      var mode: Mode = .new

      func reset(_ mode: Mode) {
        switch mode {
        case .new:
          name = ""
          description = ""
          kind = .uncleared
        case .edit(let payment):
          name = payment.name
          description = payment.introduction ?? ""
          kind = Alne.Payment.Kind.init(rawValue: Int(payment.kind)) ?? .uncleared
        }
        self.mode = mode
      }

      var isNameValid: AnyPublisher<Bool, Never> {
        $name.map { !$0.isEmpty }
           .eraseToAnyPublisher()
       }

       var isValid: AnyPublisher<Bool, Never> {
         isNameValid
       }

      var payment: Alfheim.Payment.Snapshot {
        let snapshot: Alfheim.Payment.Snapshot
        switch mode {
        case .new:
          snapshot = Alfheim.Payment.Snapshot(name: name,
                                              description: description,
                                              kind: Int16(kind.rawValue))
        case .edit(let payment):
          payment.name = name
          payment.introduction = description
          payment.kind = Int16(kind.rawValue)
          snapshot = Alfheim.Payment.Snapshot(payment)
        }
        return snapshot
      }
    }

    var validator = Validator()
    var isValid: Bool = false
    var isNew: Bool {
      return validator.mode.isNew
    }
  }
}
