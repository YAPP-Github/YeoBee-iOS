//
//  AgreeSheetReducer.swift
//  Sign
//
//  Created Hoyoung Lee on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct AgreeSheetReducer: Reducer {
    public struct State: Equatable {
        var totalChecking: Bool = false
        var privateData: Bool = false
        var serviceData: Bool = false
        var marketingDate: Bool = false
        var isEnabledCompletedButton: Bool = false
    }

    public enum Action {
        case tappedTotal(Bool)
        case tappedPrivate(Bool)
        case tappedService(Bool)
        case tappedMarkeing(Bool)
    }

    public var body: some ReducerOf<AgreeSheetReducer> {
        Reduce { state, action in
            switch action {
            case let .tappedTotal(isCheck):
                state.totalChecking = isCheck
                state.privateData = isCheck
                state.serviceData = isCheck
                state.marketingDate = isCheck
                state.isEnabledCompletedButton = isEnableCompleteButton(state: &state)
                return .none

            case let .tappedPrivate(isCheck):
                state.privateData = isCheck
                state.totalChecking = isEnableTotalChecking(state: &state)
                state.isEnabledCompletedButton = isEnableCompleteButton(state: &state)
                return .none

            case let .tappedService(isCheck):
                state.privateData = isCheck
                state.totalChecking = isEnableTotalChecking(state: &state)
                state.isEnabledCompletedButton = isEnableCompleteButton(state: &state)
                return .none

            case let .tappedMarkeing(isCheck):
                state.privateData = isCheck
                state.totalChecking = isEnableTotalChecking(state: &state)
                state.isEnabledCompletedButton = isEnableCompleteButton(state: &state)
                return .none
            }
        }
    }

    func isEnableTotalChecking(state: inout State) -> Bool {
        return state.privateData &&
        state.serviceData &&
        state.marketingDate
    }

    func isEnableCompleteButton(state: inout State) -> Bool {
        return state.privateData &&
        state.serviceData
    }
}
