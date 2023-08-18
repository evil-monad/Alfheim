//
//  CatemojiPicker.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/23.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI
import Alne

struct CatemojiPicker<Label>: View where Label: View {

  @State private var selectedCategory: Alne.Category
  @State private var isContentActive: Bool = false
  private let selection: Binding<Alne.Catemoji>
  private let label: Label

  private let catemojis: [Alne.Category: [Catemoji]]

  init(_ catemojis: [Alne.Category: [Catemoji]], selection: Binding<Catemoji>, label: Label) {
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

  private func emojis(in category: Alne.Category) -> [String] {
    catemojis[category]?.compactMap { $0.emoji } ?? []
  }
}

struct EmojiTabView: View {
  let sections: [String: [String]]
  let selection: Binding<String>

  @State private var tab: String

  init(sections: [String: [String]], selection: Binding<String>) {
    self.sections = sections
    self.selection = selection
    self._tab = State(initialValue: sections.keys.first ?? "")
  }

  var body: some View {
    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
      TabView(selection: $tab) {
        ForEach(Array(sections.keys), id: \.self) { section in
          ScrollView {
            EmojiGrid(emojis: sections[section] ?? [], selection: selection)
          }
          .tag(section)
        }
      }
      .tabViewStyle(.page)
      .ignoresSafeArea(.all, edges: .bottom)

      HStack(alignment: .center, spacing: 10) {
        ForEach(Array(sections.keys), id: \.self) { section in
          TabButton(text: section, selection: $tab)
        }
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(.thinMaterial)
      .clipShape(Capsule())
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
  }
}

struct EmojiGrid: View {
  let emojis: [String]
  let selection: Binding<String>

  var body: some View {
    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 18), count: 6), spacing: 18) {
      ForEach(emojis, id: \.self) { emoji in
        Button {
          selection.wrappedValue = emoji
        } label: {
          Text(emoji)
            .padding(.all, 4)
            .background(
              Color.white.clipShape(Circle())
                .opacity(selection.wrappedValue == emoji ? 1.0 : 0.0)
            )
        }
      }
    }
    .padding()
  }
}

struct TabButton: View {
  let text: String
  @Binding var selection: String

  var body: some View {
    Button {
      selection = text
    } label: {
      Text(text)
        .padding(.all, 4)
        .background(
          Color.white.clipShape(Circle())
            .opacity(selection == text ? 1.0 : 0.0)
        )
    }
  }
}

//#if DEBUG
//struct CatemojiPicker_Previews: PreviewProvider {
//  static var previews: some View {
//    CatemojiPicker([.transportation: Alne.Transportation.catemojis], selection: .constant(Catemoji(category: .food, emoji: "")), label: Text("Emoji"))
//  }
//}

struct EmojiSection_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EmojiTabView(
        sections: ["🍔": loadFood(),
                   "🥤": loadDrink(),
                   "🐱": loadAnimal(),
                   "🚗": loadTransportation(),
                   "🏠": loadHouse(),
                   "📱": loadObject()],
        selection: .constant("🐱")
      )
      .navigationTitle("Emojis")
    }
  }
}
//#endif
