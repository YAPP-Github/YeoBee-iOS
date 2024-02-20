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
        let expenditureTab: ExpenditureTab
        var expenseDetailItem: ExpenseDetailItem?
        var isInitialShow: Bool = true

        init(expenditureTab: ExpenditureTab, expenseItem: ExpenseItem) {
            self.expenditureTab = expenditureTab
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
                return .send(.getExpenseDetail)

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
                    cooridinator.expenditureEdit(expenseItem: state.expenseItem, expenseDetail: expenseDetail, expenditureTab: state.expenditureTab)
                }
                return .none
            }
        }
    }
}
