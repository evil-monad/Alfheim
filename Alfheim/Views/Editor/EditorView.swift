//
//  EditorView.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/2/3.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct EditorView: View {
  @Environment(\.presentationMode) var presentationMode
  var transaction: Transaction?

  var body: some View {
    NavigationView {
      Text(transaction?.notes ?? "")
        .navigationBarTitle("New Transaction")
        .navigationBarItems(leading:
          Button("Cancel") {

          }
        )
    }
  }
}

#if DEBUG
struct EditorView_Previews: PreviewProvider {
  static var previews: some View {
    EditorView(transaction: Transaction.samples().first!)
  }
}
#endif
