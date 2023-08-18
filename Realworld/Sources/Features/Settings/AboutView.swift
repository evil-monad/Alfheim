//
//  AboutView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/10/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct AboutView: View {
  var body: some View {
    List {
      Text("**Clic** is not a goal, it is a way of life.")
    }
    .listStyle(.insetGrouped)
    .navigationTitle("About")
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView()
  }
}
