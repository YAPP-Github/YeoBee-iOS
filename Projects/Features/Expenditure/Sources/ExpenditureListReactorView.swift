//
//  ExpenditureListReactorView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import DesignSystem
import Snapkit

class ExpenditureListReactorView: Reactor {
    
    enum Action {
        // actiom cases
    }
    
    enum Mutation {
        // mutation cases
    }
    
    struct State {
        //state
    }
    
    let initialState: State
    
    init() {
        // init state initialState = State(...)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        // switch action {
        // }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        // switch mutation {
        // }
        return newState
    }
    
}
