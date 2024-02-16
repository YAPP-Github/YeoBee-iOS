//
//  FilterBottomSheetItemReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct FilterBottomSheetItemReducer: Reducer {

    public struct State: Equatable, Identifiable {
        public var id: String { return expenseFilter?.rawValue ?? "total" }
        var expenseFilter: PaymentMethod?
        var isSelected: Bool

        init(expenseFilter: PaymentMethod?, isSelected: Bool = false) {
            self.expenseFilter = expenseFilter
            self.isSelected = isSelected
        }
    }

    public enum Action {
        case tappedExpenseFilter(PaymentMethod?)
    }

    public var body: some ReducerOf<FilterBottomSheetItemReducer> {
        EmptyReducer()
    }
}
