//
//  ExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureListReducer: Reducer {
    public struct State: Equatable {
    }

    public enum Action {
        
    }

    public var body: some ReducerOf<ExpenditureListReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
