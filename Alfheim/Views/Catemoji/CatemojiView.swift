//
//  CatemojiView.swift
//  Alfheim
//
//  Created by alex.huo on 2020/5/2.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct CatemojiView: View {
  @State private var selectedCategory: Category = .uncleared
  @EnvironmentObject var store: AppStore

  private var state: AppState.Catemoji {
    store.state.catemoji
  }
  private var binding: Binding<AppState.Catemoji> {
    $store.state.catemoji
  }

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
            .frame(width: 52, height: 52)
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
          self.store.dispatch(.catemoji(.toggleAddCatemoji(presenting: true)))
        }) {
          Image(systemName: "plus").padding(.vertical).padding(.leading)
        }
      }
      .padding(EdgeInsets(top: 20, leading: 14, bottom: 0, trailing: 14))
      .sheet(
        isPresented: binding.isAlertPresented,
        onDismiss: {
          self.store.dispatch(.catemoji(.toggleAddCatemoji(presenting: false)))
      }) {
        EmojiPicker(onSelected: { emoji in
          let catemoji = Catemoji(category: self.selectedCategory, emoji: emoji)
          self.store.dispatch(.catemoji(.add(catemoji)))
        })
      }

      Grid(self.emojis(in: selectedCategory), id: \.self) { emoji in
        /*
        Button(action: {
          let catemoji = Catemoji(category: self.selectedCategory, emoji: emoji)
          // context menu edit
        }) {
          Text(emoji).font(.system(size: 28))
        }*/

        Text(emoji).font(.system(size: 28))
          .contextMenu {
            Button(action: {
              let catemoji = Catemoji(category: self.selectedCategory, emoji: emoji)
              self.store.dispatch(.catemoji(.delete(catemoji)))
            }) {
              Text("Delete").foregroundColor(.red)
              Image(systemName: "trash.circle").foregroundColor(.red)
            }
            .foregroundColor(.red)
          }
      }
      .gridStyle(columns: 6)
    }
    .navigationBarTitle("Emoji")
    .padding(EdgeInsets(top: 12, leading: 4, bottom: 0, trailing: 4))
  }

  private func emojis(in category: Category) -> [String] {
    state.categorized()[category]?.compactMap { $0.emoji } ?? []
  }
}

#if DEBUG
struct CatemojiView_Previews: PreviewProvider {
  static var previews: some View {
    CatemojiView()
  }
}
#endif
