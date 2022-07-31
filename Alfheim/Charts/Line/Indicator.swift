//
//  Indicator.swift
//  Alfheim
//
//  Created by alex.huo on 2020/1/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct Indicator: View {
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.pink)
      Circle()
        .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
    }
    .frame(width: 14, height: 14)
    .shadow(color: Color.gray, radius: 3, x: 0, y: -3)
  }
}

#if DEBUG
struct Indicator_Previews: PreviewProvider {
  static var previews: some View {
    Indicator()
  }
}
#endif
