//
//  InputTextField.swift
//  Alfheim
//
//  Created by alex.huo on 2020/3/21.
//  Copyright © 2020 blessingsoft. All rights reserved.
//

import SwiftUI

/// Fuck chinese input
struct InputTextField: View {
  private let title: String
  private var text: Binding<String>
  private let keyboardType: UIKeyboardType
  private var isFirstResponder: Binding<Bool>

  init(
    _ title: String,
    text: Binding<String>,
    isFirstResponder: Binding<Bool>,
    keyboardType: UIKeyboardType = .default
  ) {
    self.title = title
    self.text = text
    self.keyboardType = keyboardType
    self.isFirstResponder = isFirstResponder
  }

  var body: some View {
    TextFieldCore(
      title: title,
      text: text,
      keyboardType: keyboardType,
      isFirstResponder: isFirstResponder
    )
  }
}

private struct TextFieldCore {
  let title: String
  var text: Binding<String>
  let keyboardType: UIKeyboardType
  var isFirstResponder: Binding<Bool>

  init(
    title: String,
    text: Binding<String>,
    keyboardType: UIKeyboardType,
    isFirstResponder: Binding<Bool>
  ) {
    self.title = title
    self.text = text
    self.keyboardType = keyboardType
    self.isFirstResponder = isFirstResponder
  }
}

extension TextFieldCore: UIViewRepresentable {
  typealias UIViewType = _UITextField

  class Coordinator: NSObject, UITextFieldDelegate {
    var view: TextFieldCore
    var didBecomeFirstResponder = false

    init(_ view: TextFieldCore) {
      self.view = view
    }

    @objc func textFieldDidChange(_ sender: _UITextField) {
      view.text.wrappedValue = sender.text ?? ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return false
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> _UITextField {
    let textField = _UITextField()
    textField.textAlignment = .right
    textField.backgroundColor = nil
    textField.placeholder = title
    textField.text = text.wrappedValue
    textField.keyboardType = keyboardType
    textField.returnKeyType = .done

    textField.addTarget(
      context.coordinator,
      action: #selector(TextFieldCore.Coordinator.textFieldDidChange(_:)),
      for: .editingChanged
    )

    textField.delegate = context.coordinator

    return textField
  }

  func updateUIView(_ textField: _UITextField, context: Context) {
    if isFirstResponder.wrappedValue && !context.coordinator.didBecomeFirstResponder {
      DispatchQueue.main.async { // break AttributedGraph loop
        textField.becomeFirstResponder()
        context.coordinator.didBecomeFirstResponder = true
      }
    } else if !isFirstResponder.wrappedValue && context.coordinator.didBecomeFirstResponder {
      DispatchQueue.main.async { // break AttributedGraph loop
        textField.resignFirstResponder()
        context.coordinator.didBecomeFirstResponder = false
      }
    }

    // Hack: fuck chinese input bug
    if !textField.isFirstResponder {
      textField.text = text.wrappedValue
    }
  }
}

private class _UITextField: UITextField {}
