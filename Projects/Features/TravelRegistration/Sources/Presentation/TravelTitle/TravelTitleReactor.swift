//
//  TravelTitleReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/24/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import UseCase
import ComposableArchitecture
import ReactorKit
import RxSwift
import RxCocoa

public final class TravelTitleReactor: Reactor {
    
    public enum Action {
        case titleTextFieldText(text: String)
        case makeTravelButtonTapped(text: String)
        case postValidation(isSuccess: Bool)
    }
    
    public enum Mutation {
        case titleTextFieldText(text: String)
        case makeTravelButtonTapped(text: String)
        case postValidation(isSuccess: Bool)
    }
    
    public struct State {
        var isValidTitleText: Bool = false
        var tripRequest: RegistTripRequest
        var postValidation: Bool = false
    }
    
    @Dependency(\.tripUseCase) var tripUseCase
    public var initialState: State
    
    init(tripRequest: RegistTripRequest) {
        self.initialState = State(tripRequest: tripRequest)
    }
    
    func postTripUseCase(title: String, tripRequest: RegistTripRequest) {
        Task {
            try await tripUseCase.postTrip(
                title,
                tripRequest.startDate,
                tripRequest.endDate,
                tripRequest.countryList,
                tripRequest.tripUserList
            )
            action.onNext(.postValidation(isSuccess: true))
        }
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .titleTextFieldText(text: let text):
            return .just(.titleTextFieldText(text: text))
        case .makeTravelButtonTapped(text: let textFieldText):
            return .just(.makeTravelButtonTapped(text: textFieldText))
        case .postValidation(isSuccess: let isSuccess):
            return .just(.postValidation(isSuccess: isSuccess))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .titleTextFieldText(text: let text):
            let isValidTitleText = isValidTitleText(text)
            newState.isValidTitleText = isValidTitleText
        case .makeTravelButtonTapped(text: let textFieldText):
            postTripUseCase(title: textFieldText, tripRequest: newState.tripRequest)
        case .postValidation(isSuccess: let isSuccess):
            newState.postValidation = isSuccess
        }
        
        return newState
    }
    
    private func isValidTitleText(_ text: String) -> Bool {
        if text.count > 0 && text.count <= 15 {
            return true
        } else {
            return false
        }
    }
}
