//
//  KeyboardAdaptive.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 1/7/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import SwiftUI

extension View {
    public func keyboardAdaptive() -> some View {
       self.modifier(KeyboardAdaptive())
     }
}

public struct KeyboardAdaptive: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
      .onDisappear(perform: UIApplication.shared.removeTapGestureRecognizer)
  }
}


extension UIApplication {
  func addTapGestureRecognizer() {
    guard let window = windows.first else { return }
    let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    tapGesture.name = "KeyboardDismissGesture"
    window.addGestureRecognizer(tapGesture)
  }

  func removeTapGestureRecognizer() {
    guard let window = windows.first else { return }

    window.gestureRecognizers?.forEach { gesture in
      if gesture.name == "KeyboardDismissGesture" {
        window.removeGestureRecognizer(gesture)
      }

    }
  }
}

extension UIApplication: UIGestureRecognizerDelegate {
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return false
  }
}
