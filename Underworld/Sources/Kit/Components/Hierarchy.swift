//
//  Recursive.swift
//  Alfheim
//
//  Created by alex.huo on 2021/6/26.
//  Copyright © 2021 blessingsoft. All rights reserved.
//

import SwiftUI

public struct HierarchyList<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
  private let recursiveView: RecursiveView<Data, RowContent>

  public init(_ data: Data, children: KeyPath<Data.Element, Data?>, rowContent: @escaping (Data.Element) -> RowContent) {
    self.recursiveView = RecursiveView(data, children: children, rowContent: rowContent)
  }

  public var body: some View {
    List {
      recursiveView
    }
  }
}

public struct RecursiveView<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
  let data: Data
  let children: KeyPath<Data.Element, Data?>
  let rowContent: (Data.Element) -> RowContent

  public init(_ data: Data, children: KeyPath<Data.Element, Data?>, rowContent: @escaping (Data.Element) -> RowContent) {
    self.data = data
    self.children = children
    self.rowContent = rowContent
  }

  public var body: some View {
    ForEach(data) { child in
      if let subChildren = child[keyPath: children] {
        DefaultExpandedDisclosureGroup() {
          RecursiveView(subChildren, children: children, rowContent: rowContent)
        } label: {
          rowContent(child)
        }
      } else {
        rowContent(child)
      }
    }
  }
}

struct DefaultExpandedDisclosureGroup<Label, Content>: View where Label: View, Content: View {
  @State var isExpanded: Bool = true
  var content: () -> Content
  var label: () -> Label

  var body: some View {
    DisclosureGroup(
      isExpanded: $isExpanded,
      content: content,
      label: label
    )
  }
}
