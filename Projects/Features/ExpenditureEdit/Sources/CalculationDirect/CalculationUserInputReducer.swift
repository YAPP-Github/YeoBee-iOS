//
//  CalculationUserInputReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/18/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct CalculationUserInputReducer: Reducer {
    public struct State: Equatable, Identifiable {
        public var id: Int { user.id }
        let user: TripUserItem
        @BindingState var text: String = ""
        var currency: Currency

        init(user: TripUserItem, text: String, currency: Currency) {
            self.user = user
            self.text = text
            self.currency = currency
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    public var body: some ReducerOf<CalculationUserInputReducer> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                default: return .none
            }
        }
    }
}
