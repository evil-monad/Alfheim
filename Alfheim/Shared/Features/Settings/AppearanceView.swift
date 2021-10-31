//
//  AppearanceView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/10/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct AppearanceView: View {
  @AppStorage("selectedAppearance") var selectedAppearance = 0

  var body: some View {
    List {
      Section {
        Text("System Default")
          .modifier(CheckmarkModifier(checked: selectedAppearance == 0))
          .contentShape(Rectangle())
          .onTapGesture {
            selectedAppearance = 0
          }

        Text("Light Mode")
          .modifier(CheckmarkModifier(checked: selectedAppearance == 1))
          .contentShape(Rectangle())
          .onTapGesture {
            selectedAppearance = 1
          }

        Text("Dark Mode")
          .modifier(CheckmarkModifier(checked: selectedAppearance == 2))
          .contentShape(Rectangle())
          .onTapGesture {
            selectedAppearance = 2
          }
      }
    }
    .onChange(of: selectedAppearance) { value in
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
