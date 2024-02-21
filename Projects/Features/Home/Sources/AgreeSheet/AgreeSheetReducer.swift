//
//  AgreeSheetReducer.swift
//  Sign
//
//  Created Hoyoung Lee on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct AgreeSheetReducer: Reducer {

    let coordinator: CreateAccountCoordinator

    init(coordinator: CreateAccountCoordinator) {
        self.coordinator = coordinator
    }
    
    public struct State: Equatable {
        var totalChecking: Bool = false
        var privateData: Bool = false
        var serviceData: Bool = false
        var isEnabledCompletedButton: Bool = false

        init() { }
    }

    public enum Action {
        case tappedTotal(Bool)
        case tappedPrivate(Bool)
        case tappedService(Bool)
        case tappedConfirmButton
    }

    public var body: some ReducerOf<AgreeSheetReducer> {
        Reduce { state, action in
            switch action {
            case let .tappedTotal(isCheck):
                state.totalChecking = isCheck
                state.privateData = isCheck
                state.serviceData = isCheck
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
            case .tappedConfirmButton:
                coordinator.onboarding()
                return .none
            }
        }
    }

    func isEnableTotalChecking(state: inout State) -> Bool {
        return state.privateData &&
        state.serviceData
    }

    func isEnableCompleteButton(state: inout State) -> Bool {
        return state.privateData &&
        state.serviceData
    }
}
