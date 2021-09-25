//
//  DisclosureRow.swift
//  Alfheim
//
//  Created by alex.huo on 2021/9/25.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct DisclosureRow<Content>: View where Content: View {
  private let alignment: VerticalAlignment
  private let spacing: CGFloat?
  @ViewBuilder
  private let content: Content

  @inlinable
  init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
    self.alignment = alignment
    self.spacing = spacing
    self.content = content()
  }

  var body: some View {
    HStack(alignment: alignment, spacing: spacing) {
      content
      Image(systemName: "chevron.forward")
        .font(.caption.weight(.bold))
        .foregroundColor(Color(UIColor.tertiaryLabel))
    }
  }
}

extension View {
  func disclosure(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) -> some View {
    DisclosureRow(alignment: alignment, spacing: spacing) {
      self
    }
  }
}

struct CheckmarkRow<Content>: View where Content: View {
  private let alignment: VerticalAlignment
  private let spacing: CGFloat?
  @ViewBuilder
  private let content: Content

  @inlinable
  init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
    self.alignment = alignment
    self.spacing = spacing
    self.content = content()
  }

  var body: some View {
    HStack(alignment: alignment, spacing: spacing) {
      content
      Image(systemName: "checkmark")
        .font(.body.bold())
        .foregroundColor(.blue)
    }
  }
}


extension View {
  func checkmark() -> some View {
    CheckmarkRow {
      self
    }
  }
}

struct DisclosureRow_Previews: PreviewProvider {
  static var previews: some View {
    DisclosureRow {
      HStack {
        Text("List Row")
        Spacer()
      }
    }
    .frame(height: 44)
    .background(.yellow)

    CheckmarkRow {
      HStack {
        Text("Checkmark Row")
        Spacer()
      }
    }
    .frame(height: 44)
    .background(.yellow)
  }
}
