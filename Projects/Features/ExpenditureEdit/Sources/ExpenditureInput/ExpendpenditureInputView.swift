//
//  ExpendpenditureInputView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureInputView: View {
    typealias State = ExpenditureInputReducer.State
    typealias Action = ExpenditureInputReducer.Action

    let store: StoreOf<ExpenditureInputReducer>

    var body: some View {
        containerView
            .padding(.horizontal, 24)
    }
}

extension ExpenditureInputView {
    var containerView: some View {
        WithViewStore(store, observe: { $0 }) { viewstore in
            VStack(alignment: .leading, spacing: 10) {
                Text("유로")
                    .foregroundColor(.ybColor(.gray6))
                    .font(.ybfont(.body3))
                VStack(alignment: .leading, spacing: 0) {
                    CurrencyTextFieldView(text: viewstore[keyPath: \.$text], placeholder: "0 $")
                    Text("= 1000원")
                        .foregroundColor(.ybColor(.gray3))
                        .font(.ybfont(.body2))
                }
            }
            .padding(22)
            .background(YBColor.white.swiftUIColor)
            .cornerRadius(10)
        }
    }
}
