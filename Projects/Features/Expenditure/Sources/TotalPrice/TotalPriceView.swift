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
                    totalExpandPriceView(price: viewStore.totalExpandPrice)
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
    func totalExpandPriceView(price: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            LargeTotalPriceView(title: "총쓴돈", price: "\(price)원")
            YBDividerView()
        }
    }

    func budgetPriceView(
        totalExpandPrice: Int,
        totalBudgetPrice: Int,
        remainBudgetPrice: Int
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            LargeTotalPriceView(title: "예산 잔액", price: "\(remainBudgetPrice)원")
            YBDividerView()
            HStack(spacing: 8) {
                SmallTotalPriceView(title: "총예산", price: "\(totalBudgetPrice)")
                verticalDividerView
                SmallTotalPriceView(title: "총쓴돈", titleColor: .mainRed, price: "\(totalExpandPrice)")
            }
            YBDividerView()
        }
    }

    var verticalDividerView: some View {
        Rectangle()
            .frame(width: 1)
            .foregroundColor(.ybColor(.gray3))
    }
}
