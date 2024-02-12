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
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    // tapp
                } label: {
                    HStack(spacing: 6) {
                        Text("\(viewStore.selectedCurrency.code) (\(viewStore.selectedCurrency.name))")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body2))
                    }
                }
                VStack(alignment: .leading, spacing: 0) {
                    CurrencyTextFieldView(text: viewStore[keyPath: \.$text], placeholder: "0") {
                        let toast = Toast.text(icon: .complete, "최대 10자까지 입력 가능해요.")
                        toast.show()
                    }
                    if viewStore.selectedCurrency.code != "KRW" {
                        Text(viewStore.selectedCurrency.code)
                            .foregroundColor(.ybColor(.gray3))
                            .font(.ybfont(.body2))
                    }
                }
            }
            .padding(22)
            .background(YBColor.white.swiftUIColor)
            .cornerRadius(10)
        }
    }
}
