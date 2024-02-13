//
//  TotalBudgetExpenditureListView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

final class TotalBudgetHostingController: UIHostingController<TotalBudgetExpenditureListView> {
}

struct TotalBudgetExpenditureListView: View {
    typealias State = TotalBudgetExpenditureListReducer.State
    typealias Action = TotalBudgetExpenditureListReducer.Action

    let store: StoreOf<TotalBudgetExpenditureListReducer>

    var body: some View {
        containerView
            .onAppear { store.send(.onAppear) }
    }
}

extension TotalBudgetExpenditureListView {

    @MainActor
    var containerView: some View {
        WithViewStore(store, observe: { $0 }) { viewstore in
            VStack(spacing: 10) {
                TotalPriceToggleView(totalPriceTab: viewstore.$seletedTotalPriceTab)
                .frame(height: 40)
                .padding(.top, 5)
                .padding(.horizontal, 24)
                TabView(selection: viewstore.$seletedTotalPriceTab) {
                    TotalExpenditureListView(
                       store: store.scope(
                        state: \.totalBudget,
                        action: TotalBudgetExpenditureListReducer.Action.totalBudget
                       )
                    )
                    .tag(TotalPriceTab.budget)
                    TotalExpenditureListView(
                       store: store.scope(
                        state: \.totalExpense,
                        action: TotalBudgetExpenditureListReducer.Action.totalExpense
                       )
                    )
                    .tag(TotalPriceTab.expense)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .background(YBColor.white.swiftUIColor, ignoresSafeAreaEdges: [.all])
        }
    }
}
