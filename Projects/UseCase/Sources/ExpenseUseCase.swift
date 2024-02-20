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
    public var getExpenseList: @Sendable (
        _ tripId: Int, 
        _ date: Date,
        _ expenseType: ExpenseType?,
        _ expenseMethod: PaymentMethod?,
        _ pageIndex: Int
    ) async throws -> ([ExpenseItem], Bool)
    public var createExpense: @Sendable (_ createExpense: CreateExpenseRequest) async throws -> CreateExpenseResponse
    public var updateExpense: @Sendable (_ expenseId: Int, _ updateExpense: CreateExpenseRequest) async throws -> CreateExpenseResponse
    public var deleteExpense: @Sendable (_ expenseId: Int) async throws -> String
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
        return .init(getExpenseList: { tripId, date, expenseType, expenseMethod, pageIndex in
            let pageSize = 20
            let data = try await expenseRepository.getExpenseList(
                request: .init(
                    tripId: tripId,
                    pageIndex: pageIndex,
                    pageSize: pageSize,
                    type: expenseType,
                    date: date,
                    method: expenseMethod
                )
            )
            return (data.content, data.number <= 20)
        }, createExpense: { request in
            let data = try await expenseRepository.createExpense(request: request)
            return data
        }, updateExpense: { expenseId, request in
            return try await expenseRepository.updateExpense(expenseId: expenseId, request: request)
        }, deleteExpense: { expenseId in
            return try await expenseRepository.deleteExpense(expenseId: expenseId)
        }, getExpenseDetail: { expenseId in
            return try await expenseRepository.getExpenseDetail(expenseId: expenseId)
        })
    }
}
