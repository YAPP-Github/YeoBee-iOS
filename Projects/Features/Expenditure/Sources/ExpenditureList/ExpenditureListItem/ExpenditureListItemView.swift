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
        let expenseItem: ExpenseItem
        var exchangedPrice: Int? = nil
        var price: String {
            return expenseItem.expenseType.symbol
            + " "
            + expenseItem.price.formattedWithSeparator
        }


        init(state: ExpenditureListItemReducer.State) {
            let expendseItem = state.expendseItem
            self.expenseItem = expendseItem
            if expendseItem.currency.suffix != "원" {
                self.exchangedPrice = Int(Double(expendseItem.price) * expendseItem.currency.exchangeRate)
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
                            Text(viewStore.expenseItem.title)
                                .foregroundColor(.ybColor(.black))
                                .font(.ybfont(.body2))
                                .lineLimit(1)
                            Spacer(minLength: 0)
                            HStack(spacing: 0) {
                                Text(viewStore.price)
                                    .foregroundColor(
                                        viewStore.expenseItem.expenseType == .expense
                                        ? .ybColor(.black)
                                        : .ybColor(.mainGreen)
                                    )
                                    .font(.ybfont(.body2))
                                    .lineLimit(1)
                                Text(viewStore.expenseItem.currency.suffix)
                                    .foregroundColor(
                                        viewStore.expenseItem.expenseType == .expense
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
