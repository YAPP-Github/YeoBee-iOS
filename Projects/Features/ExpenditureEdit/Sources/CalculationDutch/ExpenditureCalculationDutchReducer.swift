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
        let expenseType: ExpenditureType
        var expenseDetail: ExpenseDetailItem
        let tripItem: TripItem
        var payerListItems: IdentifiedArrayOf<CalculationPayerItemReducer.State> = []
        var dutchAmount: Double = .zero
        var payableList: [TripUserItem]
        var selectedPayer: TripUserItem?
        var isEnableRegisterButton: Bool = true

        init(
            expenseType: ExpenditureType,
            tripItem: TripItem,
            expenseDetail: ExpenseDetailItem,
            selectedPayer: TripUserItem?
        ) {
            self.expenseType = expenseType
            self.tripItem = tripItem
            self.expenseDetail = expenseDetail
            self.selectedPayer = selectedPayer

            var payableList: [TripUserItem] = []
            if expenseType == .expense {
                payableList = [.init(id: 0, userId: 0, name: "공동경비")] + tripItem.tripUserList
            }
            self.payableList = payableList
            if let selectedPayer {
                if expenseType == .expense { self.isEnableRegisterButton = true }
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == selectedPayer.id))
                }
            } else {
                if expenseType == .expense { self.isEnableRegisterButton = false }
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: false))
                }
            }
            self.dutchAmount =  expenseDetail.amount / Double(tripItem.tripUserList.count)
        }
    }

    public enum Action {
        case tappedConfirmButton
        case payerItem(id: CalculationPayerItemReducer.State.ID, action: CalculationPayerItemReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureCalculationDutchReducer> {
        Reduce { state, action in
            switch action {
            case let .payerItem(id: _, action: .tappedPayrtItem(tripUserItem)):
                var expenseList: [Payer] = []
                if state.expenseType == .expense { state.isEnableRegisterButton = true }
                state.selectedPayer = tripUserItem
                state.expenseDetail.payerUserId = tripUserItem.id == 0 ? nil : tripUserItem.id
                state.expenseDetail.payerName = tripUserItem.name == "공동경비" ? nil : tripUserItem.name
                state.payableList.forEach { tripUser in
                    state.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == tripUserItem.id))
                }
                state.tripItem.tripUserList.forEach { tripUser in
                    expenseList.append(.init(tripUserId: tripUser.id, amount: state.dutchAmount))
                }
                state.expenseDetail.payerList = expenseList
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
