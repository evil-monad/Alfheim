//
//  SearchBar.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/22.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
  private var text: Binding<String>
  private var placeholder: String

  var body: some View {
    SearchBarCore(text: text, placeholder: placeholder)
  }
}

private struct SearchBarCore {
  var text: Binding<String>
  var placeholder: String

  init(
    text: Binding<String>,
    placeholder: String
  ) {
    self.text = text
    self.placeholder = placeholder
  }
}

extension SearchBarCore: UIViewRepresentable {
  typealias UIViewType = _UISearchBar

  class Coordinator: NSObject, UISearchBarDelegate {
    var text: Binding<String>

    init(text: Binding<String>) {
      self.text = text
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      text.wrappedValue = searchText
    }
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(text: text)
  }

  func makeUIView(context: Context) -> UIViewType {
    let searchBar = _UISearchBar(frame: .zero)
    searchBar.delegate = context.coordinator
    searchBar.placeholder = placeholder
    searchBar.searchBarStyle = .minimal
    searchBar.autocapitalizationType = .none
    return searchBar
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.text = text.wrappedValue
  }
}

private class _UISearchBar: UISearchBar {}
