//
//  RevokeCompleteReactor.swift
//  Home
//
//  Created by 김태형 on 2/22/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import ReactorKit

public final class RevokeCompleteReactor: Reactor {
    
    public enum Action {
        case confirm
    }
    
    public enum Mutation {

    }
    
    public struct State {
        
    }
    
    public var initialState: State
    
    public init() {
        self.initialState = State()
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        
        return Observable.empty()
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
       
        return newState
    }
}
