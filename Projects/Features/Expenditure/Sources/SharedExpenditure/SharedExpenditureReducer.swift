//
//  SharedExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct SharedExpenditureReducer: Reducer {
    let cooridinator: ExpenditureCoordinator

    init(cooridinator: ExpenditureCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {
        @BindingState var selectedTab: ExpenditureTab = .shared
        var sharedExpenditure: ExpenditureReducer.State
        var individualExpenditure: ExpenditureReducer.State

        init(tripItem: TripItem) {
            self.sharedExpenditure = .init(type: .shared, tripItem: tripItem)
            self.individualExpenditure = .init(type: .individual, tripItem: tripItem)
        }
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

        Scope(state: \.sharedExpenditure, action: /Action.sharedExpenditure) {
            ExpenditureReducer(cooridinator: cooridinator)
        }

        Scope(state: \.individualExpenditure, action: /Action.individualExpenditure) {
            ExpenditureReducer(cooridinator: cooridinator)
        }
    }
}
