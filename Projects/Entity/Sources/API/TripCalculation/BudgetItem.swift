//
//  BudgetItem.swift
//  Entity
//
//  Created by Hoyoung Lee on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct Budgets: Codable {
    public var sharedBudget: BudgetItem?
    public var individualBudget: BudgetItem?
}


public struct BudgetItem: Codable {
    public var leftBudget: Int?
    public var budgetIncome: Int
    public var budgetExpense: Int
}
