//
//  AppView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/1/17.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: Store<AppState, AppAction>
  @State var boarding: Bool = false
  var body: some View {
    if boarding {
      OnboardingView()
    } else {
      MainView(store: store)
    }
  }
}
