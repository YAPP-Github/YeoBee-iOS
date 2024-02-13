//
//  ExpenditureListItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Entity

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
        let expenseItem: ExpenseItem
        var exchangedPrice: Int? = nil
        var currency: String
        var price: String {
            let price =  expenseItem.amount
            if price > 0 {
                return "+ " + price.formattedWithSeparator
            } else {
                return "- " + abs(price).formattedWithSeparator
            }
        }

        init(state: ExpenditureListItemReducer.State) {
            let expendseItem = state.expendseItem
            self.expenseItem = expendseItem
            self.currency = " \(state.expendseItem.currency)"
            if expendseItem.currency != "KRW" {
                self.exchangedPrice = abs(expendseItem.koreanAmount ?? 0)
            } else {
                self.currency = "원"
            }
        }
    }

    var containerView: some View {
        WithViewStore(store, observe: ViewState.init) { viewStore in
            Button {
                viewStore.send(.tappedExpenditureItem(viewStore.expenseItem))
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    viewStore.expenseItem.category.image
                        .frame(width: 41, height: 41)
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(alignment: .top, spacing: 9) {
                            Text(viewStore.expenseItem.name)
                                .foregroundColor(.ybColor(.black))
                                .font(.ybfont(.body2))
                                .lineLimit(1)
                            Spacer(minLength: 0)
                            HStack(spacing: 0) {
                                Text(viewStore.price)
                                    .foregroundColor(
                                        viewStore.expenseItem.amount < 0
                                        ? .ybColor(.black)
                                        : .ybColor(.mainGreen)
                                    )
                                    .font(.ybfont(.body2))
                                    .lineLimit(1)
                                Text(viewStore.currency)
                                    .foregroundColor(
                                        viewStore.expenseItem.amount < 0
                                        ? .ybColor(.black)
                                        : .ybColor(.mainGreen)
                                    )
                                    .font(.ybfont(.body2))
                            }
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
}
