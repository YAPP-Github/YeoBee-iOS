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
        var isEnableRegisterButton: Bool = true

        init(
            expenseType: ExpenditureType,
            tripItem: TripItem,
            expenseDetail: ExpenseDetailItem,
            selectedPayerId: Int?,
            hasSharedBudget: Bool
        ) {
            self.expenseType = expenseType
            self.tripItem = tripItem
            var payableList: [TripUserItem] = []
            if expenseType == .expense {
                if hasSharedBudget {
                    payableList += [.init(id: 0, userId: 0, name: "공동경비")]
                }
                payableList += tripItem.tripUserList
            }
            self.payableList = payableList
            let dutchAmount =  expenseDetail.amount / Double(tripItem.tripUserList.count)
            var expenseList: [Payer] = []
            tripItem.tripUserList.forEach { tripUser in
                expenseList.append(.init(tripUserId: tripUser.id, amount: dutchAmount))
            }
            var expenseDetailItem = expenseDetail
            expenseDetailItem.calculationType = "EQUAL"
            expenseDetailItem.payerList = expenseList
            if let selectedPayerId {
                expenseDetailItem.payerId = selectedPayerId
            } else {
                expenseDetailItem.payerId = nil
            }
            self.expenseDetail = expenseDetailItem
            self.dutchAmount = dutchAmount
            if let selectedPayerId {
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == selectedPayerId))
                }
            } else {
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == 0))
                }
            }
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
                state.expenseDetail.payerId = tripUserItem.id == 0 ? nil : tripUserItem.id
                state.expenseDetail.payerName = tripUserItem.name == "공동경비" ? nil : tripUserItem.name
                state.expenseDetail.calculationType = "EQUAL"
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
