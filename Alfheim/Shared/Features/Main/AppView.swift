//
//  AppView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/1/17.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @State var boarding: Bool = false
  var body: some View {
    if boarding {
      OnboardingView()
    } else {
      MainView()
    }
  }
}
