//
//  ExpenditureCalculationDirectReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity
import DesignSystem

public struct ExpenditureCalculationDirectReducer: Reducer {
    public struct State: Equatable {
        let expenseType: ExpenditureType
        var expenseDetail: ExpenseDetailItem
        let tripItem: TripItem
        var totalAmount: Double
        var payerListItems: IdentifiedArrayOf<CalculationPayerItemReducer.State> = []
        var tripUserListItems: IdentifiedArrayOf<CalculationUserInputReducer.State> = []
        var dutchAmount: Double = .zero
        var payableList: [TripUserItem]
        var selectedPayer: TripUserItem?
        var isInitialShow: Bool = true
        var isEnableConfirmButton: Bool = true

        init(
            expenseType: ExpenditureType,
            tripItem: TripItem,
            expenseDetail: ExpenseDetailItem,
            selectedPayer: TripUserItem?,
            hasSharedBudget: Bool
        ) {
            self.expenseType = expenseType
            self.tripItem = tripItem
            self.totalAmount = expenseDetail.amount
            self.expenseDetail = expenseDetail
            self.selectedPayer = selectedPayer

            var payableList: [TripUserItem] = []
            if expenseType == .expense {
                if hasSharedBudget {
                    payableList += [.init(id: 0, userId: 0, name: "공동경비")]
                }
                payableList += tripItem.tripUserList
            }
            self.payableList = payableList
            if let selectedPayer {
                if expenseType == .expense { self.isEnableConfirmButton = true }
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == selectedPayer.id))
                }
            } else {
                if expenseType == .expense { self.isEnableConfirmButton = false }
                payableList.forEach { tripUser in
                    self.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: false))
                }
            }
            tripItem.tripUserList.forEach { tripUser in
                self.tripUserListItems.updateOrAppend(.init(user: tripUser))
            }
            self.dutchAmount =  expenseDetail.amount / Double(tripItem.tripUserList.count)
        }
    }

    public enum Action {
        case onAppear
        case tappedConfirmButton
        case payerItem(id: CalculationPayerItemReducer.State.ID, action: CalculationPayerItemReducer.Action)
        case tripUser(id: CalculationUserInputReducer.State.ID, action: CalculationUserInputReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureCalculationDirectReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.isInitialShow {
                    state.isInitialShow = false
                    let toast = Toast.text(icon: .warning, "직접입력 하신 금액 합계로 지출 금액이 바뀌어요.")
                    toast.show()
                }
                return .none

            case let .payerItem(id: _, action: .tappedPayrtItem(tripUserItem)):
                if state.expenseType == .expense { state.isEnableConfirmButton = true }
                state.selectedPayer = tripUserItem
                state.expenseDetail.payerUserId = tripUserItem.id
                state.expenseDetail.payerName = tripUserItem.name
                state.payableList.forEach { tripUser in
                    state.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == tripUserItem.id))
                }
                return .none

            case .tripUser(id: _, action: .binding(\.$text)):
                var totalPrice: Double = .zero
                var expenseList: [Payer] = []
                state.tripUserListItems.forEach { tripUser in
                    let amountString = tripUser.text.replacingOccurrences(of: ",", with: "")
                    if let amount = Double(amountString) {
                        totalPrice += amount
                        expenseList.append(.init(tripUserId: tripUser.id, amount: amount))
                    }
                }
                state.expenseDetail.payerList = expenseList
                state.expenseDetail.amount = totalPrice
                state.totalAmount = totalPrice
                state.isEnableConfirmButton = totalPrice != .zero
                return .none

            default:
                return .none
            }
        }
        .forEach(\.payerListItems, action: /Action.payerItem) {
            CalculationPayerItemReducer()
        }
        .forEach(\.tripUserListItems, action: /Action.tripUser) {
            CalculationUserInputReducer()
        }
    }
}
