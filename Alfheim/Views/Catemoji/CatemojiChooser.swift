//
//  CatemojiChooser.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct CatemojiChooser: View {
  @State var selectedCategory: Category = .uncleared
  let catemojis: [Category: [Catemoji]]

  var onAdd: (Category) -> Void
  var onSelection: (Catemoji) -> Void

  var body: some View {
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

        Button(action: {
          self.onAdd(self.selectedCategory)
        }) {
          Image(systemName: "plus").padding(.vertical).padding(.leading)
        }
      }
      .padding(EdgeInsets(top: 20, leading: 14, bottom: 0, trailing: 14))

      Grid(self.emojis(in: selectedCategory), id: \.self) { emoji in
        Button(action: {
          let catemoji = Catemoji(category: self.selectedCategory, emoji: emoji)
          self.onSelection(catemoji)
        }) {
          Text(emoji).font(.system(size: 28))
        }
      }
      .gridStyle(columns: 6)
    }
    .navigationBarTitle("Emoji")
    .padding()
  }

  private func emojis(in category: Category) -> [String] {
    catemojis[category]?.compactMap { $0.emoji } ?? []
  }
}


struct CatemojiChooser_Previews: PreviewProvider {
  static var previews: some View {
    CatemojiChooser(
      catemojis: [.transportation: Alne.Transportation.catemojis],
      onAdd: { category in

      },
      onSelection: { catemoji in
      })
  }
}
