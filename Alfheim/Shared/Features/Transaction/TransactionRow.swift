//
//  TransactionRow.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/14.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct TransactionRow: View {
  var transaction: TransactionViewState

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(transaction.title)
          .font(.system(size: 20, weight: .medium))
          .lineLimit(1)
        Spacer()
        HStack {
          Text(transaction.from)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.green)

          if transaction.forward {
            Image(systemName: "arrow.forward").font(.system(size: 11))
          } else {
            Image(systemName: "arrow.backward").font(.system(size: 11))
          }

          Text(transaction.to)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.red)
        }
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text("\(transaction.forward ? "-" : "+")\(transaction.currency.symbol)\(String(format: "%.1f", abs(transaction.amount)))")
          .font(.system(size: 28, weight: .semibold))
          .foregroundColor(Color(tagit: transaction.tag))
        Spacer()
        Text(transaction.date.string)
          .font(.system(size: 14))
          .foregroundColor(.gray)
          .lineLimit(1)
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
      TransactionRow(transaction: TransactionViewState.mock(cxt: viewContext))
    }.padding()
  }
}
#endif
