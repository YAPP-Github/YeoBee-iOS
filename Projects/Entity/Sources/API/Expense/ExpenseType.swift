//
//  ExpenseType.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 지출 타입을 위한 Enum
enum ExpenseType: String, Codable {
    case shared = "SHARED"
    case individual = "INDIVIDUAL"
    case sharedBudgetIncome = "SHARED_BUDGET_INCOME"
    case sharedBudgetExpense = "SHARED_BUDGET_EXPENSE"
    case individualBudgetExpense = "INDIVIDUAL_BUDGET_EXPENSE"
}
