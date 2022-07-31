//
//  PaymentRow.swift
//  Alfheim
//
//  Created by alex.huo on 2020/4/20.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct PaymentRow: View {
  var model: PaymentViewModel

  var body: some View {
    HStack {
      Text(model.name)
      Spacer()
      Text(model.kind.fullname.lowercased())
        .fontWeight(.light)
        .font(Font.system(size: 12))
        .padding(4)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color(tagit: model.tag), lineWidth: 1)
      )
    }
    .contentShape(Rectangle())
  }
}

#if DEBUG
struct PaymentRow_Previews: PreviewProvider {
  static var previews: some View {
    PaymentRow(model: PaymentViewModel.mock)
  }
}
#endif
