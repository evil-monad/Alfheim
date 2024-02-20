//
//  AppearanceView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/10/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import Kit

struct AppearanceView: View {
  @AppStorage("selectedAppearance") var selectedAppearance = 0

  var body: some View {
    List {
      Section {
        Text("System")
          .modifier(CheckmarkModifier(checked: selectedAppearance == Theme.system.rawValue))
          .contentShape(Rectangle())
          .onTapGesture {
            selectedAppearance = Theme.system.rawValue
          }

        Text("Light")
          .modifier(CheckmarkModifier(checked: selectedAppearance == Theme.light.rawValue))
          .contentShape(Rectangle())
          .onTapGesture {
            selectedAppearance = Theme.light.rawValue
          }

        Text("Dark")
          .modifier(CheckmarkModifier(checked: selectedAppearance == Theme.dark.rawValue))
          .contentShape(Rectangle())
          .onTapGesture {
            selectedAppearance = Theme.dark.rawValue
          }
      }
    }
    .onChange(of: selectedAppearance) {
      Appearance.shared.overrideDisplayMode()
    }
    .navigationTitle("Appearance")
  }

  struct CheckmarkModifier: ViewModifier {
    var checked: Bool = false
    func body(content: Content) -> some View {
      HStack(spacing: 10) {
        content
        Spacer()
        if checked {
          Image(systemName: "checkmark")
            .font(Font.body.bold())
            .foregroundColor(.blue)
        }
      }
    }
  }
}

struct AppearanceView_Previews: PreviewProvider {
  static var previews: some View {
    AppearanceView()
  }
}
