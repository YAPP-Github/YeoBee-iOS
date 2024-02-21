//
//  BudgetItem.swift
//  Entity
//
//  Created by Hoyoung Lee on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct Budgets: Codable {
    public var sharedBudget: SharedBudgetItem?
    public var individualBudget: BudgetItem?
}


public struct BudgetItem: Codable {
    public var leftBudget: Int?
    public var budgetIncome: Int
    public var budgetExpense: Int
}

public struct SharedBudgetItem: Codable {
    public var leftBudget: Int?
    public var budgetIncome: Int
    public var budgetExpense: Int
    public var totalExpense: Int
}
