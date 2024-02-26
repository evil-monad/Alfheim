//
//  TransactionDetail.swift
//  
//
//  Created by alex.huo on 2023/9/9.
//

import SwiftUI
import Domain

struct TransactionDetail: View {
  var state: Transactions.ViewState

  var body: some View {
    List {
      Section {
        Field("Amount", value: "\(state.displayAmount)")
        Field("Account") {
          Text(state.from)
            .font(.footnote).fontWeight(.medium)
            .foregroundColor(.green)

          if state.forward {
            Image(systemName: "arrow.forward").font(.caption)
          } else {
            Image(systemName: "arrow.backward").font(.caption)
          }

          Text(state.to)
            .font(.footnote).fontWeight(.medium)
            .foregroundColor(.red)
        }
      }

      Section {
        Field("Date", value: state.date.formatted())

        Field("Notes", value: state.transaction.notes)
      }

      Section {
        Field("Payee", value: state.transaction.payee)
        Field("Number", value: "\(state.transaction.number ?? "0")")
        Field("Repeat", value: "\(state.transaction.repeated)")
        Field("Cleared", value: "\(state.transaction.cleared)".capitalized)
      }
    }
  }
}

private struct Field<Content: View>: View {
  let name: String
  let content: Content

  init(_ name: String, @ViewBuilder content: () -> Content) {
    self.name = name
    self.content = content()
  }

  var body: some View {
    HStack {
      Text(name)
        .foregroundColor(.primary)
      Spacer()
      content
        .foregroundColor(.secondary)
    }
  }
}

extension Field where Content == Text {
  init(_ name: String, value: String?) {
    self.init(name) {
      Text(value ?? "")
    }
  }
}

struct TransactionDetail_Previews: PreviewProvider {
    static var previews: some View {
      TransactionDetail(state: .init(transaction: .mock, tag: .alfheim))
    }
}

extension Domain.Account.Summary {
  static func mock(name: String) -> Domain.Account.Summary {
    Domain.Account.Summary(id: UUID(), name: "Cash", introduction: "Cash account", group: .assets, currency: .cny, tag: "", emoji: "💵", descendants: nil, ancestors: nil)
  }
}

extension Domain.Transaction {
  static var mock: Self {
    Domain.Transaction(id: UUID(), amount: 233, currency: .cny, date: Date(), notes: "This is notes", payee: "Starbucks", number: nil, repeated: 0, cleared: true, flagged: false, target: .mock(name: "Cash"), source: .mock(name: "Coffee"), attachments: [])
  }
}
