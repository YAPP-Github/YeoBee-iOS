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
    public typealias Action = NoAction
    
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
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
