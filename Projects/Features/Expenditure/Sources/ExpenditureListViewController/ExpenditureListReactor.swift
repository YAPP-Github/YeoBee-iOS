//
//  ExpenditureListReactorView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

import DesignSystem

public final class ExpenditureListReactor: Reactor {

    public enum Action {
        case setTripDateLoad
    }
    
    public enum Mutation {
        case setDiffableDatasourceSanpshot(NSDiffableDataSourceSnapshot<Expenditure, String>)
    }
    
    public struct State {
        var snapshot: NSDiffableDataSourceSnapshot<Expenditure, String>
    }

    public let initialState: State
    public let totalPriceReactorFactory: TotalPriceReactor

    public init(totalPriceReactorFactory: @escaping (Int, Int, Int) -> TotalPriceReactor) {
        self.totalPriceReactorFactory = totalPriceReactorFactory(0, 100000, 0)
        self.initialState = .init(snapshot: .init())
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .setTripDateLoad:
             let snapshot = configureSnapshot(data: ["11", "22"])
             return .just(.setDiffableDatasourceSanpshot(snapshot))
         }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
         switch mutation {
         case let .setDiffableDatasourceSanpshot(snapshot):
             newState.snapshot = snapshot
         }
        return newState
    }
}

extension ExpenditureListReactor {
    func configureSnapshot(data: [String]) ->  NSDiffableDataSourceSnapshot<Expenditure, String> {
        var snapshot = NSDiffableDataSourceSnapshot<Expenditure, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
