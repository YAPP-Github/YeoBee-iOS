//
//  ExpenditureCalculationDirectReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct ExpenditureCalculationDirectReducer: Reducer {
    public struct State: Equatable {
    }

    public enum Action {
    }

    public var body: some ReducerOf<ExpenditureCalculationDirectReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
