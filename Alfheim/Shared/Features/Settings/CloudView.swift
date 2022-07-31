//
//  CloudView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/10/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct CloudView: View {
  var body: some View {
    List {
      Section {
        Toggle(isOn: .constant(true)) {
          Text("Cloud sync")
        }
      } footer: {
        Text("Keep your data up-to-date between your iPhone, iPad and Mac. Data is securely store on iCloud.")
      }
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Cloud")
  }
}

struct CloudView_Previews: PreviewProvider {
  static var previews: some View {
    CloudView()
  }
}
