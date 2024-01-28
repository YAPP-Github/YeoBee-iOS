//
//  TotalPriceView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture

import DesignSystem

struct TotalPriceView: View {
    typealias State = TotalPriceReducer.State
    typealias Action = TotalPriceReducer.Action

    let store: StoreOf<TotalPriceReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.totalBudgetPrice <= 0 {
                    totalExpandPriceView(price: viewStore.totalExpandPrice, isTappable: viewStore.isTappable)
                } else {
                    budgetPriceView(
                        totalExpandPrice: viewStore.totalExpandPrice,
                        totalBudgetPrice: viewStore.totalBudgetPrice,
                        remainBudgetPrice: viewStore.remainBudgetPrice
                    )
                }
            }
        }
    }
}

extension TotalPriceView {
    func totalExpandPriceView(price: Int, isTappable: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            LargeTotalPriceView(title: "총쓴돈", price: price) {
                store.send(.tappedTotalPrice)
            }
            .disabled(!isTappable)
        }
    }

    func budgetPriceView(
        totalExpandPrice: Int,
        totalBudgetPrice: Int,
        remainBudgetPrice: Int
    ) -> some View {
        WithViewStore(store, observe: \.type) { viewStore in
            VStack(alignment: .leading, spacing: 8) {
                LargeTotalPriceView(
                    title: viewStore.state == .individual ? "예산 잔액" : "공동경비 잔액",
                    price: remainBudgetPrice
                ) {
                    store.send(.tappedBubgetPrice)
                }
                YBDividerView()
                HStack(spacing: 8) {
                    SmallTotalPriceView(
                        title: viewStore.state == .individual ? "총예산" : "모인돈",
                        price: totalBudgetPrice
                    )
                    verticalDividerView
                    SmallTotalPriceView(
                        title: "총쓴돈",
                        titleColor: .mainRed,
                        price: totalExpandPrice
                    )
                }
                .frame(height: 24)
                YBDividerView()
            }
        }
    }

    var verticalDividerView: some View {
        Rectangle()
            .frame(width: 1)
            .foregroundColor(.ybColor(.gray3))
    }
}
