//
//  AgreeSheetReducer.swift
//  Sign
//
//  Created Hoyoung Lee on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

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
        var nickName: String

        init(nickName: String) {
            self.nickName = nickName
        }
    }

    public enum Action {
        case tappedTotal(Bool)
        case tappedPrivate(Bool)
        case tappedService(Bool)
        case tappedConfirmButton
        case showOnboarding
    }

    @Dependency(\.userInfoUseCase) var userInfoUseCase

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
                state.serviceData = isCheck
                state.totalChecking = isEnableTotalChecking(state: &state)
                state.isEnabledCompletedButton = isEnableCompleteButton(state: &state)
                return .none
            case .tappedConfirmButton:
                coordinator.onboarding()
                return .run { [nickName = state.nickName] send in
                    let request = UpdateUserInfoRequest(nickname: nickName)
                    let stateRequest = UpdateUserStateRequest(userState: .onboardingCompleted)
                    try await userInfoUseCase.updateUserInfo(request)
                    try await userInfoUseCase.updateUserState(stateRequest)
                    await send(.showOnboarding)
                } catch: { error, send in
                    print(error)
                }

            case .showOnboarding:
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
