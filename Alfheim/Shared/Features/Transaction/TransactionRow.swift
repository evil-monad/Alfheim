//
//  TransactionRow.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/14.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct TransactionRow: View {
  var transaction: Transactions.ViewState

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(transaction.title)
          .font(.title3).fontWeight(.medium)
          .lineLimit(1)
        Spacer()
        HStack {
          Text(transaction.from)
            .font(.footnote).fontWeight(.medium)
            .foregroundColor(.green)

          if transaction.forward {
            Image(systemName: "arrow.forward").font(.caption)
          } else {
            Image(systemName: "arrow.backward").font(.caption)
          }

          Text(transaction.to)
            .font(.footnote).fontWeight(.medium)
            .foregroundColor(.red)
        }
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text(transaction.displayAmount)
          .font(.title2).fontWeight(.semibold)
          .foregroundColor(Color(tagit: transaction.tag))
        Spacer()
        HStack {
          Text(transaction.date.alfheim)
            .font(.footnote)
            .foregroundColor(.gray)
            .lineLimit(1)

          if transaction.flagged {
            Image(systemName: "flag.fill")
              .resizable()
              .foregroundColor(.blue)
              .frame(width: 10, height: 10)
          }
        }
      }
    }
    .padding(.vertical, 16)
    .frame(height: 64)
  }
}

#if DEBUG
struct TransactionRow_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      TransactionRow(transaction: Transactions.ViewState.mock(cxt: viewContext))
    }
    .padding()
  }
}
#endif
