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
        let expenseDetail: ExpenseDetailItem
        let tripItem: TripItem
        var totalAmount: Double
        var payerListItems: IdentifiedArrayOf<CalculationPayerItemReducer.State> = []
        var tripUserListItems: IdentifiedArrayOf<CalculationUserInputReducer.State> = []
        var dutchAmount: Double = .zero
        var payableList: [TripUserItem]
        var selectedPayer: TripUserItem?
        var isInitialShow: Bool = true

        init(
            tripItem: TripItem,
            expenseDetail: ExpenseDetailItem,
            selectedPayer: TripUserItem?
        ) {
            self.tripItem = tripItem
            self.totalAmount = expenseDetail.amount
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
            tripItem.tripUserList.forEach { tripUser in
                self.tripUserListItems.updateOrAppend(.init(user: tripUser))
            }
            self.dutchAmount =  expenseDetail.amount / Double(tripItem.tripUserList.count)
        }
    }

    public enum Action {
        case onAppear
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
                state.selectedPayer = tripUserItem
                state.payableList.forEach { tripUser in
                    state.payerListItems.updateOrAppend(.init(user: tripUser, isChecked: tripUser.id == tripUserItem.id))
                }
                return .none

            case .tripUser(id: _, action: .binding(\.$text)):
                var totalPrice: Double = .zero
                state.tripUserListItems.forEach { tripUser in
                    let amountString = tripUser.text.replacingOccurrences(of: ",", with: "")
                    if let amount = Double(amountString) {
                        totalPrice += amount
                    }
                }
                state.totalAmount = totalPrice
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
