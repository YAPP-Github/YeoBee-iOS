//
//  TripCalculationReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/21/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct TripCalculationReducer: Reducer {
    public struct State: Equatable {
        var calculations: [Calculation] = []
        let tripItem: TripItem

        init(tripItem: TripItem) {
            self.tripItem = tripItem
        }

    }

    public enum Action {
        case onAppear
        case setCalculations([Calculation])
    }

    @Dependency(\.tripCalculationUseCase) var tripCalculation

    public var body: some ReducerOf<TripCalculationReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let calulations =  try await tripCalculation.getCalculation(state.tripItem.id)
                    await send(.setCalculations(calulations))
                }
            case let .setCalculations(calculaitons):
                state.calculations = calculaitons
                return .none
            }
        }
    }
}
