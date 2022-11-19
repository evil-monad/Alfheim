//
//  AppIconView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/10/31.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AppIconView: View {
  let store: Store<Settings.State, Settings.Action>

  var body: some View {
    WithViewStore(store) { vs in
      List(AppIcon.allCases) { icon in
        HStack(spacing: 10) {
          Image(uiImage: UIImage(named: icon.icon) ?? UIImage())
            .cornerRadius(13.36)
            .overlay(
              RoundedRectangle(cornerRadius: 13.36)
                .stroke(Color.primary.opacity(0.1), lineWidth: 0.5))
            .shadow(color: Color.primary.opacity(0.1), radius: 4)

          Text(icon.name)
          Spacer()
          if icon == vs.appIcon {
            Image(systemName: "checkmark")
              .font(Font.body.bold())
              .foregroundColor(.blue)
          }
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
          vs.send(.selectAppIcon(icon))
        }
      }
      .navigationBarTitle("App Icon")
    }
  }
}

#if DEBUG
struct AppIconView_Previews: PreviewProvider {
  static var previews: some View {
    AppIconView(
      store: Store(
        initialState: Settings.State(isPresented: false, appIcon: .primary),
        reducer: Settings()
      )
    )
  }
}
#endif
