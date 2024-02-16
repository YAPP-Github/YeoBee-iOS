//
//  FilterBottomSheetReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

import Foundation
import ComposableArchitecture
import Entity

public struct FilterBottomSheetReducer: Reducer {

    let cooridinator: ExpenditureCoordinator

    init(cooridinator: ExpenditureCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {
        var expenseFilterStates: IdentifiedArrayOf<FilterBottomSheetItemReducer.State> = []
        var selectedExpenseFilter: PaymentMethod?

        public init(selectedExpenseFilter: PaymentMethod?) {
            self.selectedExpenseFilter = selectedExpenseFilter
            self.expenseFilterStates.updateOrAppend(.init(
                expenseFilter: nil,
                isSelected: selectedExpenseFilter == nil
            ))
            [PaymentMethod.card, PaymentMethod.cash].forEach {
                self.expenseFilterStates.updateOrAppend(.init(
                    expenseFilter: $0,
                    isSelected: $0.rawValue == selectedExpenseFilter?.rawValue
                ))
            }
        }
    }

    public enum Action {
        case expenseFilter(FilterBottomSheetItemReducer.State.ID, FilterBottomSheetItemReducer.Action)
    }

    public var body: some ReducerOf<FilterBottomSheetReducer> {
        Reduce { state, action in
            switch action {
            case let .expenseFilter(_, .tappedExpenseFilter(selectedExpenseFilter)):
                state.expenseFilterStates.updateOrAppend(.init(
                    expenseFilter: nil,
                    isSelected: selectedExpenseFilter == nil
                ))
                [PaymentMethod.card, PaymentMethod.cash].forEach { expenseFilter in
                    state.expenseFilterStates.updateOrAppend(.init(
                        expenseFilter: expenseFilter,
                        isSelected: expenseFilter.rawValue == selectedExpenseFilter?.rawValue
                    ))
                }
                state.selectedExpenseFilter = selectedExpenseFilter
                cooridinator.selectExpenseFilter(selectedExpenseFilter: selectedExpenseFilter)
                return .none
            }
        }
        .forEach(\.expenseFilterStates, action: /Action.expenseFilter) {
            FilterBottomSheetItemReducer()
        }
    }
}
