//
//  ExpenditurePaymentView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditurePaymentView: View {
    typealias State = ExpenditurePaymentReducer.State
    typealias Action = ExpenditurePaymentReducer.Action

    let store: StoreOf<ExpenditurePaymentReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditurePaymentView {
    var containerView: some View {
        HStack(alignment: .center, spacing: 10) {
            HStack(spacing: 0) {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    Text(viewStore.isExpense ? "지출형태" : viewStore.isShared ? "경비형태" : "예산형태")
                        .foregroundColor(.ybColor(.black))
                        .font(.ybfont(.title1))
                }
                Text("*")
                    .foregroundColor(.ybColor(.mainGreen))
                    .font(.ybfont(.body3))
            }
            Spacer()
            HStack(spacing: 12) {
                paymentButtonView(type: .cash)
                paymentButtonView(type: .card)
            }
        }
        .padding(.horizontal, 24)
    }


    func paymentButtonView(type: Payment) -> some View {
        WithViewStore(store, observe: \.seletedPayment) { viewstore in
            Button(action: {
                viewstore.send(.setPayment(type))
            }, label: {
                Text(type.text)
                    .foregroundColor(type == viewstore.state ? .ybColor(.white) : .ybColor(.black))
                    .font(.ybfont(.body1))
                    .frame(width: 90, height: 44)
            })
            .background(type == viewstore.state ? YBColor.gray6.swiftUIColor : YBColor.gray3.swiftUIColor)
            .cornerRadius(10)
        }

    }
}

extension Payment {
    var text: String {
        switch self {
        case .cash: return "현금"
        case .card: return "카드"
        }
    }
}
