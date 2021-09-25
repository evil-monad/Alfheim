//
//  Grid.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/1.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct Grid<Data, ID, SelectionValue, Content> : View where Data: RandomAccessCollection, ID : Hashable, SelectionValue == Data.Element {

  struct Item: Identifiable {
    let id: ID
    let content: AnyView
    let data: Data.Element
  }
  
  private var numberOfRows: Int {
    if items.count % style.columns == 0 {
      return items.count / style.columns
    } else {
      return items.count / style.columns + 1
    }
  }

  @Environment(\.gridStyle) private var style

  let items: [Item]
  let selection: Binding<SelectionValue>?

  var body: some View {
    GeometryReader { proxy in
      ScrollView {
        VStack(alignment: .leading, spacing: self.style.spacing) {
          ForEach(0..<self.numberOfRows, id: \.self) { row in
            HStack(spacing: self.style.spacing) {
              ForEach(self.items(at: row)) { item in
                item.content.onTapGesture {
                  self.selection?.wrappedValue = item.data
                }
                .frame(width: self.itemWidth(in: proxy), height: self.itemWidth(in: proxy))
              }
              if self.items.count < self.style.columns {
                Spacer()
              }
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  private func items(at row: Int) -> [Item] {
    if row < numberOfRows - 1 || items.count % style.columns == 0 {
      return Array(items[style.columns * row ..< style.columns * row + style.columns])
    } else if row == numberOfRows - 1 {
      return Array(items[style.columns * row ..< style.columns * row + items.count % style.columns])
    } else {
      fatalError("row out of bounds")
    }
  }

  private func itemWidth(in geo: GeometryProxy) -> CGFloat {
    (geo.size.width - CGFloat(style.columns - 1) * style.spacing) / CGFloat(style.columns)
  }
}

extension Grid where ID == Data.Element.ID, Content : View, Data.Element : Identifiable {
  init(_ data: Data, selection: Binding<SelectionValue>? = nil, @ViewBuilder item: @escaping (Data.Element) -> Content) {
    self.items = data.map { Item(id: $0.id, content: AnyView(item($0)), data: $0) }
    self.selection = selection
  }
}

extension Grid where Content : View {
  init(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue>? = nil, @ViewBuilder item: @escaping (Data.Element) -> Content) {
    self.items = data.map { Item(id: $0[keyPath: id], content: AnyView(item($0)), data: $0) }
    self.selection = selection
  }
}

struct GridSyle {
  var columnsInPortrait: Int
  var columnsInLandscape: Int

  let spacing: CGFloat

  var columns: Int {
    #if os(OSX) || os(tvOS) || targetEnvironment(macCatalyst)
    return columnsInLandscape
    #elseif os(watchOS)
    return columnsInPortrait
    #else
    let screenSize = UIScreen.main.bounds.size
    return screenSize.width > screenSize.height ? columnsInLandscape : columnsInPortrait
    #endif
  }
}

struct GridStyleKey: EnvironmentKey {
  static let defaultValue = GridSyle(columnsInPortrait: 6,
                                     columnsInLandscape: 8,
                                     spacing: 0)
}

extension EnvironmentValues {
  var gridStyle: GridSyle {
    get { self[GridStyleKey.self] }
    set { self[GridStyleKey.self] = newValue }
  }
}

extension View {
  func gridStyle(columns: Int = 6, spacing: CGFloat = 0) -> some View {
    let style = GridSyle(
      columnsInPortrait: columns,
      columnsInLandscape: columns,
      spacing: spacing
    )
    return self.environment(\.gridStyle, style)
  }

}

#if DEBUG
struct Grid_Previews: PreviewProvider {
  static var previews: some View {
    Grid(["🤗", "👀", "🤤", "😚",  "🍌", "🧚‍♀️", "😉", "🤷‍♂️"], id: \.self, selection: nil) {
      Text($0)
    }
  }
}
#endif
