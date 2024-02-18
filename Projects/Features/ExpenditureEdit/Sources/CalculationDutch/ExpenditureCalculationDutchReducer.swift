//
//  ExpenditureCalculationDutchReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct ExpenditureCalculationDutchReducer: Reducer {
    public struct State: Equatable {
        let expenseDetail: ExpenseDetailItem
        let tripItem: TripItem
        var payerListItems: IdentifiedArrayOf<CalculationPayerItemReducer.State> = []
        var dutchAmount: Double = .zero
        var payableList: [TripUserItem]
        var selectedPayer: TripUserItem?

        init(
            tripItem: TripItem,
            expenseDetail: ExpenseDetailItem,
            selectedPayer: TripUserItem?
        ) {
            self.tripItem = tripItem
            self.expenseDetail = expenseDetail
            self.selectedPayer = selectedPayer

            // 예산이 있는 경우
            let payableList = [.init(id: 0, userId: 0, name: "공동경비")] + tripItem.tripUserList
            self.payableList = payableList
            if let selectedPayer {
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == selectedPayer.id))
                }
            } else {
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: false))
                }
            }
            self.dutchAmount =  expenseDetail.amount / Double(tripItem.tripUserList.count)
        }
    }

    public enum Action {
        case payerItem(id: CalculationPayerItemReducer.State.ID, action: CalculationPayerItemReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureCalculationDutchReducer> {
        Reduce { state, action in
            switch action {
            case let .payerItem(id: _, action: .tappedPayrtItem(tripUserItem)):
                state.selectedPayer = tripUserItem
                state.payableList.forEach { tripUser in
                    state.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == tripUserItem.id))
                }
                return .none
            default: 
                return .none
            }
        }
        .forEach(\.payerListItems, action: /Action.payerItem) {
            CalculationPayerItemReducer()
        }
    }
}
