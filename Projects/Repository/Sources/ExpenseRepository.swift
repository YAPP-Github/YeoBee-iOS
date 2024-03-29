//
//  ExpenseRepository.swift
//  Repository
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity

public protocol ExpenseRepositoryInterface {
    func getExpenseList(request: FetchExpenseListRequest) async throws -> FetchExpenseListResponse
    func getExpenseDetail(expenseId: Int) async throws -> ExpenseDetailItem
    func createExpense(request: CreateExpenseRequest) async throws -> CreateExpenseResponse
    func deleteExpense(expenseId: Int) async throws -> String
    func updateExpense(expenseId: Int, request: CreateExpenseRequest) async throws -> CreateExpenseResponse
}

final public class ExpenseRepository: ExpenseRepositoryInterface {

    public init() {}

    let provider = MoyaProvider<ExpenseService>(plugins: [NetworkLogger()])

    public func getExpenseList(request: FetchExpenseListRequest) async throws -> FetchExpenseListResponse {
         let result = await provider.request(
            .fetchList(
                tripId: request.tripId,
                pageIndex: request.pageIndex,
                pageSize: request.pageSize,
                type: request.type?.rawValue,
                date: request.date,
                paymentMethod: request.method?.apiText,
                unitId: request.unitId
            )
        )
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }

    public func getExpenseDetail(expenseId: Int) async throws -> ExpenseDetailItem {
         let result = await provider.request(
            .fetchDetail(expenseId)
        )
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }

    public func createExpense(request: CreateExpenseRequest) async throws -> CreateExpenseResponse {
        let result = await provider.request(
            .create(request)
        )
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }

    public func deleteExpense(expenseId: Int) async throws -> String {
        let result = await provider.request(
            .delete(expenseId)
        )
        switch result {
        case .success:
            return ""
        case .failure(let failure):
            throw failure
        }
    }

    public func updateExpense(expenseId: Int, request: CreateExpenseRequest) async throws -> CreateExpenseResponse {
        let result = await provider.request(
            .update(expenseId, request)
        )
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
}
