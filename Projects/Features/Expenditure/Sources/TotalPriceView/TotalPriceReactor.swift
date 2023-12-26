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
        let totalBudget: Int
        let totalExpandPrice: Int
        let remainBudget: Int
    }
    
    public let initialState: State

    public init(
        totalBudget: Int,
        totalExpandPrice: Int,
        remainBudget: Int
    ) {
        self.initialState = .init(
            totalBudget: totalBudget,
            totalExpandPrice: totalExpandPrice,
            remainBudget: remainBudget
        )
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
