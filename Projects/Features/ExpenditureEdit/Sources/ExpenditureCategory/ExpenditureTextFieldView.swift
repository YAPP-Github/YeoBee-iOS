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
    var focus: FocusState<Bool>.Binding
    @Binding var text: String
    private let placeholder: String

    public init(
        text: Binding<String>,
        focused: FocusState<Bool>.Binding,
        placeholder: String
    ) {
        self._text = text
        self.focus = focused
        self.placeholder = placeholder
    }

    var body: some View {
        VStack {
            TextField("", text: $text)
                .focused(focus)
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
        .id("expenditureCategoryType")
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
