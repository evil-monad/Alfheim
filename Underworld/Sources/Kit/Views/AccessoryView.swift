//
//  AccessoryView.swift
//  Alfheim
//
//  Created by alex.huo on 2021/9/25.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

public struct RowAccessoryView<Content, Accessory>: View where Content: View, Accessory: View {
  private let accessory: Accessory
  private let alignment: VerticalAlignment
  private let spacing: CGFloat?
  private let content: Content

  public init(
    alignment: VerticalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content,
    @ViewBuilder accessory: () -> Accessory
  ) {
    self.alignment = alignment
    self.spacing = spacing
    self.content = content()
    self.accessory = accessory()
  }

  public var body: some View {
    HStack(alignment: alignment, spacing: spacing) {
      content
      accessory
    }
    .padding()
  }
}

public struct AccessoryView {
  public enum AccessoryType: Int {
    case none
    case disclosure
    case checkmark
    // case detail
  }
}

public extension View {
  func accessory(
    _ type: AccessoryView.AccessoryType,
    alignment: VerticalAlignment = .center,
    spacing: CGFloat? = nil
  ) -> some View {
    HStack(alignment: alignment, spacing: spacing) {
      self
      switch type {
      case .disclosure:
        Image(systemName: "chevron.forward")
          .font(.caption.weight(.bold))
          .foregroundColor(Color(UIColor.tertiaryLabel))
      case .checkmark:
        Image(systemName: "checkmark")
          .font(.body.bold())
          .foregroundColor(.blue)
      case .none:
        EmptyView()
      }
    }
  }
}

struct AccessoryView_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      Text("List Row")
      Spacer()
    }
    .accessory(.disclosure)
    .padding()
    .frame(height: 44)
    .background(.yellow)
  }
}
