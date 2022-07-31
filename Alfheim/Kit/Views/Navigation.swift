//
//  Navigation.swift
//  Navigation
//
//  Created by alex.huo on 2021/8/22.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

struct NavigationRow<Label, Destination> : View where Label : View, Destination : View {
  private let label: Label
  private let link: NavigationLink<EmptyView, Destination>

  init<V>(tag: V, selection: Binding<V?>, @ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) where V : Hashable {
    self.label = label()
    self.link = NavigationLink(tag: tag, selection: selection, destination: destination) {
      EmptyView()
    }
  }

  var body: some View {
    ZStack {
      label

      link
        .buttonStyle(.plain)
        .opacity(0)
    }
  }
}

struct NavigationRow_Previews: PreviewProvider {
  static var previews: some View {
    NavigationRow(tag: 1, selection: .constant(1)) {
      Text("Navigation Destination")
    } label: {
      Text("NavigationLow")
    }
  }
}

struct DestinationLink<Label, Destination> : View where Label : View, Destination : View {
  private let isActive: Binding<Bool>
  @ViewBuilder private let destination: () -> Destination
  private let label: Label

  init(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination, @ViewBuilder label: () -> Label) {
    self.isActive = isActive
    self.destination = destination
    self.label = label()
  }

  var body: some View {
    ZStack {
      label.allowsHitTesting(false)

      NavigationLink(isActive: isActive, destination: destination) {
        EmptyView()
      }
      .buttonStyle(.plain)
      .opacity(0)
    }
  }
}

struct DestinationLink_Previews: PreviewProvider {
  static var previews: some View {
    DestinationLink(isActive: .constant(false)) {
      Text("estination Destination")
    } label: {
      Text("Link")
    }
  }
}
