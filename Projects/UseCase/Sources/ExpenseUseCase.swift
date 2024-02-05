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
    public var getExpenseList: @Sendable (_ tripId: String) async throws -> String
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
        return .init(getExpenseList: { tripId in
//            let data = try await expenseRepository.getExpenseList(request: .init(tripId: 0, pageIndex: 0, pageSize: 0))
            return "냠냠"
        })
    }
}
