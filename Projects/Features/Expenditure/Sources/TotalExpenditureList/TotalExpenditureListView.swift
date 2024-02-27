//
//  TotalExpenditureListView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/24/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

final class TotalExpenditureListHostingController: UIHostingController<TotalExpenditureListView> {
}

struct TotalExpenditureListView: View {
    typealias State = TotalExpenditureListReducer.State
    typealias Action = TotalExpenditureListReducer.Action

    let store: StoreOf<TotalExpenditureListReducer>

    var body: some View {
        totalPriceView
    }
}

extension TotalExpenditureListView {
    var totalPriceView: some View {
        VStack {
            TotalPriceView(
                store: store.scope(
                    state: \.totalPrice,
                    action: Action.totalPrice
                )
            )
            .padding(.top, 24)
            .padding(.horizontal, 24)
            Rectangle()
                .frame(height: 10)
                .foregroundColor(YBColor.gray1.swiftUIColor)
//            ExpenditureListView(
//                store: store.scope(
//                    state: \.expenditureList,
//                    action: Action.expenditureList
//                )
//            )
//            .padding(.all, 24)
        }
    }
}
