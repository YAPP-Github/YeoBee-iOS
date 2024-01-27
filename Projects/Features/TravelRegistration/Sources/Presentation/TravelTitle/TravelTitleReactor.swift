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
import ReactorKit
import RxSwift
import RxCocoa

public final class TravelTitleReactor: Reactor {
    
    public enum Action {
        case titleTextFieldText(text: String)
    }
    
    public enum Mutation {
        case titleTextFieldText(text: String)
    }
    
    public struct State {
        var isValidTitleText: Bool = false
        var tripRequest: TripRequest
    }
    
    public var initialState: State
    
    init(tripRequest: TripRequest) {
        self.initialState = State(tripRequest: tripRequest)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .titleTextFieldText(text: let text):
            return .just(.titleTextFieldText(text: text))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .titleTextFieldText(text: let text):
            let isValidTitleText = isValidTitleText(text)
            newState.isValidTitleText = isValidTitleText
        }
        
        return newState
    }
    
    private func isValidTitleText(_ text: String) -> Bool {
        return text.count <= 15
    }
}
