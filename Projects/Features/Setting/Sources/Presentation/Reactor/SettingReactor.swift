//
//  SettingReactor.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import TravelRegistration
import Entity
import UseCase
import ComposableArchitecture
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingReactor: Reactor {
    
    public enum Action {
        case companions([TripUserItem])
        case currencies([Currency])
    }
    
    public enum Mutation {
        case companions([TripUserItem])
        case currencies([Currency])
    }
    
    public struct State {
        var companions: [TripUserItem] = []
        var currencies: [Currency] = []
        var tripItem: TripItem
    }
    
    @Dependency(\.currencyUseCase) var currencyUseCase
    public var initialState: State
    
    public init(tripItem: TripItem) {
        self.initialState = State(tripItem: tripItem)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .companions(let companions):
            return .just(.companions(companions))
        case .currencies(let currencies):
            return .just(.currencies(currencies))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .companions(let companions):
            newState.companions.append(contentsOf: companions)
        case .currencies(let currencies):
            newState.currencies.append(contentsOf: currencies)
        }
        
        return newState
    }
    
    func settingUseCase() {
        let currentTripItem = currentState.tripItem
        let companions = currentTripItem.tripUserList
        action.onNext(.companions(companions))
        
        Task {
            let currencyResult = try await currencyUseCase.getTripCurrencies(currentTripItem.id)
            action.onNext(.currencies(currencyResult))
        }
    }
}
