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

        init(expenseItem: ExpenseItem) {
            self.expenseItem = expenseItem
        }
    }

    public enum Action {
        case tappedEditButton
    }

    public var body: some ReducerOf<ExpenditureDetailReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
