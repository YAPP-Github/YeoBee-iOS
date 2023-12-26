//
//  TotalPriceViewReactorView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import DesignSystem
import SnapKit

public class TotalPriceReactor: Reactor {

    public enum Action {
        // actiom cases
    }
    
    public enum Mutation {
        // mutation cases
    }
    
    public struct State {
        let budget: Int
    }
    
    public let initialState: State

    public init(budget: Int) {
        self.initialState = .init(budget: budget)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        // switch action {
        // }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        // switch mutation {
        // }
        return newState
    }
    
}
