//
//  EmojiPicker.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/1.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct EmojiPicker: View {
  typealias Emoji = String
  let emojis: [Emoji]
  let numbersPerRow = 6
  let onSelected: (Emoji) -> Void

  init(onSelected: @escaping (Emoji) -> Void) {
    self.emojis = loadEmojis()
    self.onSelected = onSelected
  }

  private var numberOfRows: Int {
    if emojis.count % numbersPerRow == 0 {
      return emojis.count / numbersPerRow
    } else {
      return emojis.count / numbersPerRow + 1
    }
  }

  var body: some View {
    Grid(emojis, id: \.self) { emoji in
      Button(action: {
        self.onSelected(emoji)
      }) {
        Text(emoji).font(.title)
      }
    }
    .gridStyle(columns: 6)
    .navigationBarTitle("Emoji")
    .padding()
  }


  /*
  private var columns: [GridItem] {
    [
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]
  }

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(emojis, id: \.self) { emoji in
          Button(action: {
            self.onSelected(emoji)
          }) {
            Text(emoji).font(.title)
          }
        }
      }
    }
    .navigationBarTitle("Emoji")
    .padding()
  }
   */
}

#if DEBUG
struct CatemojisPicker_Previews: PreviewProvider {
  static var previews: some View {
    EmojiPicker() { emoji in
    }
    .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
  }
}
#endif
