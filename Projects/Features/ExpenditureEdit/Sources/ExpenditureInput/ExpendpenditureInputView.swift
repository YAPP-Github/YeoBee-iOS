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
                    viewStore.send(.tappedCurrencyButton(viewStore.selectedCurrency))
                } label: {
                    HStack(spacing: 3) {
                        Text("\(viewStore.selectedCurrency.code) (\(viewStore.selectedCurrency.name))")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body2))
                        DesignSystemAsset.Icons.dropdown.swiftUIImage
                            .frame(width: 20, height: 20)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    CurrencyTextFieldView(text: viewStore[keyPath: \.$text], placeholder: "0") {
                        let toast = Toast.text(icon: .complete, "최대 10자까지 입력 가능해요.")
                        toast.show()
                    }
                    if viewStore.selectedCurrency.code != "KRW" {
                        let amountString = viewStore.text.replacingOccurrences(of: ",", with: "")
                        if let amount = Double(amountString) {
                            let convertedAmount = viewStore.selectedCurrency.exchangeRate.value * amount
                            Text("= " + convertedAmount.formattedWithSeparator + "원")
                                .foregroundColor(.ybColor(.gray4))
                                .font(.ybfont(.body2))
                        } else {
                            Text("= 0원")
                                .foregroundColor(.ybColor(.gray4))
                                .font(.ybfont(.body2))
                        }
                    }
                }
            }
            .padding(22)
            .background(YBColor.white.swiftUIColor)
            .cornerRadius(10)
        }
    }
}
