//
//  SettingReactor.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingReactor: Reactor {
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState: State = State()
    
    public init() {
        
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        }
        
        return newState
    }
}
