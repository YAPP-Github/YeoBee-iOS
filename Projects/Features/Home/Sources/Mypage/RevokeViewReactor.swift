//
//  RevokeViewReactor.swift
//  MyPage
//
//  Created by 김태형 on 2/21/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import ReactorKit

public final class RevokeViewReactor: Reactor {
    
    public enum Action {
        case toggleCheckButton
    }
    
    public enum Mutation {
        case setCheckButtonState(Bool)
    }
    
    public struct State {
        var isCheckButtonChecked: Bool = false
    }
    
    public var initialState: State
    
    public init() {
        self.initialState = State()
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleCheckButton:
            let newState = !currentState.isCheckButtonChecked
            return Observable.just(Mutation.setCheckButtonState(newState))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCheckButtonState(let isChecked):
            newState.isCheckButtonChecked = isChecked
        }
        return newState
    }
}
