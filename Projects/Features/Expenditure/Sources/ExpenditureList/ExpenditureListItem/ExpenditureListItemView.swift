//
//  ExpenditureListItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureListItemView: View {
    typealias State = ExpenditureListItemReducer.State
    typealias Action = ExpenditureListItemReducer.Action

    let store: StoreOf<ExpenditureListItemReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureListItemView {

    struct ViewState: Equatable {
        var expenseItem: ExpenseItem
        var exchangedPrice: Int? = nil

        init(state: ExpenditureListItemReducer.State) {
            let expendseItem = state.expendseItem
            self.expenseItem = expendseItem
            if expendseItem.currency.prefix != "원" {
                self.exchangedPrice = Int(Double(expendseItem.price) * expendseItem.currency.exchangeRate)
            }
        }
    }

    var containerView: some View {
        WithViewStore(store, observe: ViewState.init) { viewStore in
            HStack(alignment: .top, spacing: 12) {
                viewStore.expenseItem.category.image
                    .frame(width: 41, height: 41)
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(alignment: .top, spacing: 9) {
                        Text(viewStore.expenseItem.title)
                            .foregroundColor(.ybColor(.black))
                            .font(.ybfont(.body2))
                            .lineLimit(1)
                        Spacer(minLength: 0)
                        Text(viewStore.expenseItem.price.formattedWithSeparator + viewStore.expenseItem.currency.prefix)
                            .foregroundColor(.ybColor(.black))
                            .font(.ybfont(.body2))
                            .lineLimit(1)
                    }
                    if let exchangedPrice = viewStore.exchangedPrice {
                        Text(exchangedPrice.formattedWithSeparator + "원")
                            .foregroundColor(.ybColor(.gray5))
                            .font(.ybfont(.body3))
                            .lineLimit(1)
                    }
                }
                .padding(.top, 5)

            }
        }
    }
}
