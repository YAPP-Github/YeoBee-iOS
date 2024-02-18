//
//  OnboardingReducer.swift
//  Onboarding
//
//  Created Hoyoung Lee on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct OnboardingReducer: Reducer {
    let coordinator: OnboardingCoordinator

    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }

    public struct State: Equatable {
        @BindingState var onboadingTab: OnboardingTab = .register
        var buttonText: String = "다음으로"
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tappedNextButton(OnboardingTab)
    }

    public var body: some ReducerOf<OnboardingReducer> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .tappedNextButton(tab):
                switch tab {
                case .register:
                    state.onboadingTab = .manage
                    state.buttonText = "다음으로"
                case .manage:
                    state.onboadingTab = .calculate
                    state.buttonText = "시작하기"
                case .calculate:
                    coordinator.home()
                }
                return .none
            default:
                return .none
            }
        }
    }
}
