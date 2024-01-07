//
//  ExpenditureTextFieldView.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import SwiftUI
import DesignSystem

struct ExpenditureTextFieldView: View {
    @FocusState private var isFocused: Bool
    @Binding var text: String
    private let placeholder: String

    public init(
        text: Binding<String>,
        placeholder: String
    ) {
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        VStack {
            TextField("", text: $text)
                .focused($isFocused)
                .foregroundColor(.ybColor(.black))
                .font(.ybfont(.body1))
                .overlay(alignment: .leading) {
                    placeholderView
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 13)
        }
        .background(YBColor.white.swiftUIColor)
        .cornerRadius(10)
    }
}

extension ExpenditureTextFieldView  {
    private var placeholderView: some View {
        Text(placeholder)
            .foregroundColor(.ybColor(.gray4))
            .font(.ybfont(.body1))
            .opacity(text.isEmpty ? 1 : 0)
    }
}
