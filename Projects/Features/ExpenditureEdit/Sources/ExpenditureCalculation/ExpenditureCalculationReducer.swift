//
//  ExpenditureCalculationReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct ExpenditureCalculationReducer: Reducer {
    let coordinator: ExpenditureAddCoordinator

    init(coordinator: ExpenditureAddCoordinator) {
        self.coordinator = coordinator
    }
    public struct State: Equatable {
        @BindingState var seletedCalculationType: CalculationType = .dutch
        var dutch: ExpenditureCalculationDutchReducer.State
        var direct: ExpenditureCalculationDirectReducer.State
        let expenseType: ExpenditureType

        init(
            expenseType: ExpenditureType,
            tripItem: TripItem,
            expenseDetail: ExpenseDetailItem,
            selectedPayer: TripUserItem?,
            hasSharedBudget: Bool
        ) {
            var expenseDetailItem = expenseDetail
            self.seletedCalculationType = expenseDetail.calculationType == "EQUAL" ? .dutch : .direct
            if expenseDetail.calculationType == "CUSTOM" {
                let totalAmount = expenseDetail.payerList.reduce(0) { $0 + $1.amount }
                if totalAmount != expenseDetail.amount {
                    self.seletedCalculationType = .dutch
                    expenseDetailItem.calculationType = "EQUAL"
                }
             }
            self.expenseType = expenseType
            self.dutch = .init(
                expenseType: expenseType,
                tripItem: tripItem,
                expenseDetail: expenseDetailItem,
                selectedPayerId: expenseDetail.payerId,
                hasSharedBudget: hasSharedBudget
            )
            self.direct = .init(
                expenseType: expenseType,
                tripItem: tripItem,
                expenseDetail: expenseDetailItem,
                selectedPayerId: expenseDetail.payerId,
                hasSharedBudget: hasSharedBudget
            )
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<ExpenditureCalculationReducer.State>)
        case dutch(ExpenditureCalculationDutchReducer.Action)
        case direct(ExpenditureCalculationDirectReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureCalculationReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .direct(.tappedConfirmButton):
                coordinator.setCalculationData(expenseDetail: state.direct.expenseDetail, expenseType: state.expenseType)
                return .none
            case .dutch(.tappedConfirmButton):
                coordinator.setCalculationData(expenseDetail: state.dutch.expenseDetail, expenseType: state.expenseType)
                return .none
            default:
                return .none
            }
        }

        Scope(state: \.dutch, action: /Action.dutch) {
            ExpenditureCalculationDutchReducer()
        }

        Scope(state: \.direct, action: /Action.direct) {
            ExpenditureCalculationDirectReducer()
        }
    }
}
