//
//  View+Modal.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

extension View {
  func modal<Content: View>(
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content) -> some View {
    background(
      EmptyView()
        .sheet(
          isPresented: isPresented,
          onDismiss: onDismiss,
          content: content)
    )
  }
}
