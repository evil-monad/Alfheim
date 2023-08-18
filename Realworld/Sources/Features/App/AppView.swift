//
//  AppView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/1/17.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct AppView: View {
  let store: Store<App.State, App.Action>
  @State var boarding: Bool = false
  public var body: some View {
    if boarding {
      OnboardingView()
    } else {
      MainView(store: store)
    }
  }
}
