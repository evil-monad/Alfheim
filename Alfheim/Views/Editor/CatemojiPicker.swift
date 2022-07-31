//
//  CatemojiPicker.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/23.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct CatemojiPicker<Label>: View where Label: View {

  @State private var selectedCategory: Category
  @State private var isContentActive: Bool = false
  private let selection: Binding<Alne.Catemoji>
  private let label: Label

  private let catemojis: [Category: [Catemoji]]

  init(_ catemojis: [Category: [Catemoji]], selection: Binding<Catemoji>, label: Label) {
    self.catemojis = catemojis
    self.selection = selection
    self.label = label
    self._selectedCategory = State(initialValue: selection.wrappedValue.category)
  }

  var body: some View {
    NavigationLink(destination: content, isActive: $isContentActive) {
      HStack {
        label
        Spacer()
        Text(selection.wrappedValue.emoji)
      }
    }
  }

  private var content: some View {
    VStack(alignment: .leading) {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
          ForEach(Category.allCases, id: \.self) { category in
            Button(action: {
              self.selectedCategory = category
            }) {
              ZStack {
                if self.selectedCategory == category {
                  Circle().foregroundColor(Color.gray).opacity(0.2)
                }
                Text(category.text).font(.system(size: 28))
              }
            }
            .frame(width: 44, height: 44)
          }
        }
        .padding(.leading, 10)
        .padding(.trailing, 16)
      }

      HStack {
        Text(selectedCategory.name.uppercased())
          .bold()

        Spacer()
      }
      .padding(EdgeInsets(top: 20, leading: 14, bottom: 0, trailing: 14))

      Grid(self.emojis(in: selectedCategory), id: \.self) { emoji in
        Button(action: {
          self.selection.wrappedValue = Catemoji(category: self.selectedCategory, emoji: emoji)
          self.isContentActive = false
        }) {
          Text(emoji).font(.system(size: 28))
        }
      }
      .gridStyle(columns: 6)
    }
    .navigationBarTitle("Emoji")
    .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 4))
  }

  private func emojis(in category: Category) -> [String] {
    catemojis[category]?.compactMap { $0.emoji } ?? []
  }
}

#if DEBUG
struct CatemojiPicker_Previews: PreviewProvider {
  static var previews: some View {
    CatemojiPicker([.transportation: Alne.Transportation.catemojis], selection: .constant(Alne.Catemoji(category: .food, emoji: "")), label: Text(""))
  }
}
#endif
