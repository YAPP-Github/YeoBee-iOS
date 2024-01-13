//
//  ChangeCompanionNameReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

public final class ChangeCompanionNameReactor: Reactor {
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        var companion: Companion
    }
    
    public let initialState: State
    
    init(companion: Companion) {
        self.initialState = .init(companion: companion)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        
        
        return newState
    }
}
