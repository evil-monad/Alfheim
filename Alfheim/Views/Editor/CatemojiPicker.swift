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
  private let selection: Binding<Catemoji>
  private let label: Label

  init(selection: Binding<Catemoji>, label: Label) {
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
            ZStack {
              if self.selectedCategory == category {
                Circle().foregroundColor(Color.gray).opacity(0.2)
              }
              Text(category.text).font(.system(size: 28))
            }
            .contentShape(Rectangle())
            .onTapGesture {
              self.selectedCategory = category
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
        }) {
          Image(systemName: "plus")
        }
      }
      .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))

      Grid(self.emojis(in: selectedCategory), id: \.self) { emoji in
        Text(emoji).font(.system(size: 28))
          .onTapGesture {
            self.selection.wrappedValue = Catemoji(category: self.selectedCategory, emoji: emoji)
            self.isContentActive = false
          }
      }
      .gridStyle(columns: 6)
    }
    .navigationBarTitle("Catemoji")
    .padding()
  }

  private func emojis(in category: Category) -> [String] {
    switch category {
    case .food:
      return Alne.Food.allCases.map { $0.emoji }
    case .drink:
      return Alne.Drink.allCases.map { $0.emoji }
    case .fruit:
      return Alne.Fruit.allCases.map { $0.emoji }
    case .clothes:
      return Alne.Clothes.allCases.map { $0.emoji }
    case .household:
      return Alne.Household.allCases.map { $0.emoji }
    case .personal:
      return Alne.Personal.allCases.map { $0.emoji }
    case .transportation:
      return Alne.Transportation.allCases.map { $0.emoji }
    case .services:
      return ["Services"]
    case .uncleared:
      return ["Uncleared"]
    }
  }
}

#if DEBUG
struct CatemojiPicker_Previews: PreviewProvider {
  static var previews: some View {
    CatemojiPicker(selection: .constant(Catemoji(category: .food, emoji: "")), label: Text(""))
  }
}
#endif
