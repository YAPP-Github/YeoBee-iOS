//
//  ExpenditureCalculationDirectView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureCalculationDirectView: View {
    typealias State = ExpenditureCalculationDirectReducer.State
    typealias Action = ExpenditureCalculationDirectReducer.Action

    let store: StoreOf<ExpenditureCalculationDirectReducer>

    var body: some View {
        ScrollView(showsIndicators: false) {
            contentView
                .onAppear { store.send(.onAppear) }
        }
    }
}

extension ExpenditureCalculationDirectView {
    var contentView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(viewStore.expenseDetail.currency)
                        .foregroundColor(.ybColor(.gray4))
                        .font(.ybfont(.body2))
                    Text(viewStore.totalAmount.formattedWithSeparator)
                        .foregroundColor(.ybColor(.gray4))
                        .font(.ybfont(.header1))
                }
                .padding(.bottom, 30)
                YBDividerView()
                    .padding(.bottom, 20)
                VStack(alignment: .leading, spacing: 20) {
                    Text("결제자")
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body2))
                    ForEachStore(
                        store.scope(
                            state: \.payerListItems,
                            action: ExpenditureCalculationDirectReducer.Action.payerItem
                        )
                    ) { store in
                        CalculationPayerItemView(store: store)
                    }
                }
                .padding(.bottom, 20)
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        Text("돈 낼 사람")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body2))
                        ForEachStore(
                            store.scope(
                                state: \.tripUserListItems,
                                action: ExpenditureCalculationDirectReducer.Action.tripUser
                            )
                        ) { store in
                            CalculationUserInputView(store: store)
                        }
                    }
                }
            }
            .padding(20)
            .background(YBColor.white.swiftUIColor)
            .cornerRadius(10)
        }
    }
}
