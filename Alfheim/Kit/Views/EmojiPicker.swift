//
//  EmojiPicker.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/1.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct EmojiPicker<Label>: View where Label: View {
  typealias Emoji = String
  private var emojis: [Emoji]
  private let numbersPerRow = 6

  @State private var isContentActive: Bool = false
  private let label: Label
  private let selection: Binding<Emoji?>

  init(selection: Binding<Emoji?>,
       @ViewBuilder label: @escaping () -> Label) {
    self.emojis = loadEmojis()
    self.selection = selection
    self.label = label()
  }

  var body: some View {
    NavigationLink(destination: content, isActive: $isContentActive) {
      HStack {
        label
        Spacer()
        Text(selection.wrappedValue ?? "")
      }
    }
  }

  private var numberOfRows: Int {
    if emojis.count % numbersPerRow == 0 {
      return emojis.count / numbersPerRow
    } else {
      return emojis.count / numbersPerRow + 1
    }
  }

  private var content: some View {
    Grid(emojis, id: \.self) { emoji in
      Button {
        selection.wrappedValue = emoji
        isContentActive = false
      } label: {
        Text(emoji).font(.title)
      }
    }
    .gridStyle(columns: 6)
    .navigationTitle("Emoji")
    .padding()
    .task {
      // load emoji
    }
  }
}

#if DEBUG
struct CatemojisPicker_Previews: PreviewProvider {
  static var previews: some View {
    EmojiPicker(selection: .constant("🍕")) {
      Text("Emoji")
    }
    .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
  }
}
#endif
