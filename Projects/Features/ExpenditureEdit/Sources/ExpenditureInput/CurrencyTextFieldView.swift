//
//  CurrencyTextFieldView.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import SwiftUI

struct CurrencyTextFieldView: View {
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
        TextField("", text: $text)
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .foregroundColor(.ybColor(.black))
            .font(.ybfont(.header1))
            .overlay(alignment: .leading) {
                placeholderView
            }
    }
}

extension CurrencyTextFieldView  {
    private var placeholderView: some View {
        Text(placeholder)
            .foregroundColor(.ybColor(.gray4))
            .font(.ybfont(.header1))
            .opacity(text.isEmpty ? 1 : 0)
    }
}
