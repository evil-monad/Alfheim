//
//  HelpView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/10/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct HelpView: View {
  var body: some View {
    List {
      Text("mailto: [xspyhack@gmail.com](mailto:xspyhack@gmail.com)")
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Help")
  }
}

struct HelpView_Previews: PreviewProvider {
  static var previews: some View {
    HelpView()
  }
}
