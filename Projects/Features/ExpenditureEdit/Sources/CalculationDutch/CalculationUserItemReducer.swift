//
//  CalculationPayerItemReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct CalculationPayerItemReducer: Reducer {
    public struct State: Equatable, Identifiable {
        public var id: Int { user.id }
        let user: TripUserItem
        let isChecked: Bool

        init(user: TripUserItem, isChecked: Bool) {
            self.user = user
            self.isChecked = isChecked
        }
    }

    public enum Action {
        case tappedPayrtItem(TripUserItem)
    }

    public var body: some ReducerOf<CalculationPayerItemReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
