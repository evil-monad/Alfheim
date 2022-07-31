//
//  ImportView.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/5/29.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

//struct ImportView: View {
//  // alternative dismiss
//  @Environment(\.presentationMode) var presentationMode
//  @EnvironmentObject var store: AppStore
//
//  var body: some View {
//    VStack {
//      Spacer()
//      Text("Import transactions from file")
//
//      Spacer()
//      Button(action: {
//        self.store.dispatch(.startImport)
//      }) {
//        Text("Import")
//          .fontWeight(.bold)
//          .foregroundColor(Color.ah03)
//          .padding(.horizontal, 16)
//          .padding(.vertical, 8)
//          .overlay(
//            RoundedRectangle(cornerRadius: 18)
//              .stroke(Color.ah03, lineWidth: 2)
//          )
//      }
//      .padding(.bottom, 40)
//    }
//    .navigationBarItems(
//      leading: Button(action: {
//        self.presentationMode.wrappedValue.dismiss()
//      }) {
//        Text("Cancel")
//      }
//    )
//  }
//}
//
//#if DEBUG
//struct ImportView_Previews: PreviewProvider {
//  static var previews: some View {
//    ImportView()
//  }
//}
//#endif
