//
//  CalculationReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct CalculationReducer: Reducer {
    public struct State: Equatable {
    }

    public enum Action {
    }

    public var body: some ReducerOf<CalculationReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
