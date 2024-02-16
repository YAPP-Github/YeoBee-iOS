//
//  ExpenditureDetailReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/27/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct ExpenditureDetailReducer: Reducer {

    let cooridinator: ExpenditureCoordinator

    init(cooridinator: ExpenditureCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {
        let expenseItem: ExpenseItem
        var expenseDetailItem: ExpenseDetailItem?
        var isInitialShow: Bool = true

        init(expenseItem: ExpenseItem) {
            self.expenseItem = expenseItem
        }
    }

    public enum Action {
        case onAppear
        case getExpenseDetail
        case setExpenseDetail(ExpenseDetailItem)
        case tappedEditButton
    }

    @Dependency(\.expenseUseCase) var expenseUseCase

    public var body: some ReducerOf<ExpenditureDetailReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.isInitialShow {
                    state.isInitialShow = false
                    return .send(.getExpenseDetail)
                }
                return .none

            case .getExpenseDetail:
                return .run { [expenseId = state.expenseItem.id] send in
                    let expenseDetail = try await expenseUseCase.getExpenseDetail(expenseId)
                    await send(.setExpenseDetail(expenseDetail))
                } catch: { error, send in
                    print(error)
                }
            case let .setExpenseDetail(item):
                state.expenseDetailItem = item
                return .none

            case .tappedEditButton:
                if let expenseDetail = state.expenseDetailItem {
                    cooridinator.expenditureEdit(expenseDetail: expenseDetail)
                }
                return .none

            }
        }
    }
}
