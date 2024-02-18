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
            selectedPayer: TripUserItem?
        ) {
            self.expenseType = expenseType
            self.dutch = .init(
                expenseType: expenseType,
                tripItem: tripItem,
                expenseDetail: expenseDetail,
                selectedPayer: selectedPayer
            )
            self.direct = .init(
                expenseType: expenseType,
                tripItem: tripItem,
                expenseDetail: expenseDetail,
                selectedPayer: selectedPayer
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
