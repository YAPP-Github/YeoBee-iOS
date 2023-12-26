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

public final class ExpenditureListReactor: Reactor {
    
    public enum Action {
        // actiom cases
    }
    
    public enum Mutation {
        // mutation cases
    }
    
    public struct State {
    }
    
    public let initialState: State
    public let totalPriceReactorFactory: TotalPriceReactor

    public init(totalPriceReactorFactory: @escaping (Int, Int, Int) -> TotalPriceReactor) {
        self.totalPriceReactorFactory = totalPriceReactorFactory(100000, 500000, 30000)
        self.initialState = .init()
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
