//
//  ExpenditureListItemReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct ExpenditureListItemReducer: Reducer {
    public struct State: Equatable, Identifiable {
        public var id: UUID { UUID() }
        var title: String = ""
        var price: Int = 0
        var koreanPrice: Int = 0
    }

    public enum Action {
    }

    public var body: some ReducerOf<ExpenditureListItemReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
