//
//  SharedExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public enum ExpenditureTab: Equatable {
    case shared
    case individual
}

public struct SharedExpenditureReducer: Reducer {

    public struct State: Equatable {
        @BindingState var selectedTab: ExpenditureTab = .shared
        var sharedExpenditure = ExpenditureReducer.State(type: .shared, tripId: 1, startDate: Date(), endDate: Date())
        var individualExpenditure = ExpenditureReducer.State(type: .individual, tripId: 1, startDate: Date(), endDate: Date())
    }

    public enum Action: BindableAction {
        case sharedExpenditure(ExpenditureReducer.Action)
        case individualExpenditure(ExpenditureReducer.Action)
        case binding(BindingAction<SharedExpenditureReducer.State>)
    }

    public var body: some ReducerOf<SharedExpenditureReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            default:
                return .none
            }
        }

//        Scope(state: \.sharedExpenditure, action: /Action.sharedExpenditure) {
//            ExpenditureReducer()
//        }

//        Scope(state: \.individualExpenditure, action: /Action.individualExpenditure) {
//            ExpenditureReducer()
//        }
    }
}
