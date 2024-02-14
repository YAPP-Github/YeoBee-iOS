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
    public var getExpenseList: @Sendable (_ tripId: Int, _ date: Date, _ pageIndex: Int) async throws -> ([ExpenseItem], Bool)
    public var createExpense: @Sendable (_ createExpense: CreateExpenseRequest) async throws -> CreateExpenseResponse
    public var getExpenseDetail: @Sendable (_ expenseId: Int) async throws -> ExpenseDetailItem
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

extension ExpenseUseCase: DependencyKey {
    public static var liveValue: ExpenseUseCase {
        let expenseRepository = ExpenseRepository()
        return .init(getExpenseList: { tripId, date, pageIndex in
            let pageSize = 20
            let data = try await expenseRepository.getExpenseList(
                request: .init(
                    tripId: tripId,
                    pageIndex: pageIndex,
                    pageSize: pageSize,
                    date: date
                )
            )
            return (data.content, data.number <= 20)
        }, createExpense: { request in
            let data = try await expenseRepository.createExpense(request: request)
            return data
        }, getExpenseDetail: { expenseId in
            return try await expenseRepository.getExpenseDetail(expenseId: expenseId)
        })
    }
}
