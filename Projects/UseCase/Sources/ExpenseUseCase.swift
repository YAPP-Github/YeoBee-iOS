//
//  ExpenseUseCase.swift
//  UseCase
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

import Repository
import Entity
import ComposableArchitecture

public struct ExpenseUseCase {
    public var getExpenseList: @Sendable (_ tripId: Int, _ date: Date) async throws -> [ExpenseItem]
    public var createExpense: @Sendable (_ createExpense: CreateExpenseRequest) async throws -> CreateExpenseResponse
}

extension ExpenseUseCase: TestDependencyKey {
    public static let testValue: Self = unimplemented()
}

extension DependencyValues {
    public var expenseUseCase: ExpenseUseCase {
        get { self[ExpenseUseCase.self] }
        set { self[ExpenseUseCase.self] = newValue }
    }
}

extension ExpenseUseCase {
    public static func live(
        expenseRepository: ExpenseRepositoryInterface
    ) -> Self {
        return .init(getExpenseList: { tripId, date in
            let data = try await expenseRepository.getExpenseList(
                request: .init(
                    tripId: tripId,
                    pageIndex: 0,
                    pageSize: 30,
                    date: date
                )
            )
            return data.content
        }, createExpense: { request in
            let data = try await expenseRepository.createExpense(request: request)
            return data
        })
    }
}
