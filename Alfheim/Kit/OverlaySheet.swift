//
//  OverlaySheet.swift
//  Alfheim
//
//  Created by bl4ckra1sond3tre on 2020/5/17.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct OverlaySheet<Content: View>: View {
  private let isPresented: Binding<Bool>
  private let makeContent: () -> Content
  private let onDismiss: (() -> Void)?

  @GestureState private var translation = CGPoint.zero

  init(isPresented: Binding<Bool>,
       onDismiss: (() -> Void)? = nil,
       @ViewBuilder content: @escaping () -> Content) {
    self.isPresented = isPresented
    self.onDismiss = onDismiss
    self.makeContent = content
  }

  var body: some View {
    ZStack {
      VStack {
        Spacer()
        makeContent()
      }
      .offset(y: (isPresented.wrappedValue ? 0 : UIScreen.main.bounds.height) + max(0, translation.y))
      .animation(.default, value: isPresented.wrappedValue)
      .onTapGesture {
      }
    }
    .background(isPresented.wrappedValue ? Color.gray.opacity(0.5) : Color.clear)
    .animation(.default, value: isPresented.wrappedValue)
    .edgesIgnoringSafeArea(.all)
    .onTapGesture {
      self.onDismiss?()
    }
  }

  var panelDraggingGesture: some Gesture {
    DragGesture()
      .updating($translation) { current, state, _ in
        state.y = current.translation.height
      }
      .onEnded { state in
        if state.translation.height > 250 {
          self.isPresented.wrappedValue = false
        }
      }
  }
}

extension View {
  func overlaySheet<Content: View>(
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    overlay(
      OverlaySheet(isPresented: isPresented,
                   onDismiss: onDismiss,
                   content: content)
    )
  }
}
