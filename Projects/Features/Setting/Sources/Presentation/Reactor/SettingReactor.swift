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
        case tripItem(TripItem)
        case deleteTrip(Bool)
    }
    
    public enum Mutation {
        case companions([TripUserItem])
        case currencies([Currency])
        case tripItem(TripItem)
        case deleteTrip(Bool)
    }
    
    public struct State {
        var companions: [TripUserItem] = []
        var currencies: [Currency] = []
        var tripItem: TripItem
        var deletedTrip: Bool = false
    }
    
    @Dependency(\.tripUseCase) var tripUseCase
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
        case .tripItem(let tripItem):
            return .just(.tripItem(tripItem))
        case .deleteTrip(let isDeleted):
            return .just(.deleteTrip(isDeleted))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .companions(let companions):
            newState.companions = companions
        case .currencies(let currencies):
            newState.currencies = currencies
        case .tripItem(let tripItem):
            newState.tripItem = tripItem
        case .deleteTrip(let isDeleted):
            newState.deletedTrip = isDeleted
        }
        
        return newState
    }
    
    func settingUseCase() {
        let currentTripItem = currentState.tripItem
        let companions = currentTripItem.tripUserList
        if companions.count > 1 {
            action.onNext(.companions(companions))
        }
        
        updateCurrencyUseCase()
    }
    
    func updateSettingUseCase() {
        let currentTripItem = currentState.tripItem
        
        Task {
            let tripResult = try await tripUseCase.getTrip(currentTripItem.id)
            let companionsResult = tripResult.tripUserList
            action.onNext(.tripItem(tripResult))
            if companionsResult.count > 1 {
                action.onNext(.companions(companionsResult))
            }
        }
    }
    
    func updateCurrencyUseCase() {
        let currentTripItemId = currentState.tripItem.id
        
        Task {
            let currencyResult = try await currencyUseCase.getTripCurrencies(currentTripItemId)
            action.onNext(.currencies(currencyResult))
        }
    }
    
    func deleteTripUseCase() {
        let currentTripItem = currentState.tripItem
        
        Task {
            let deleteTripResult = try await tripUseCase.deleteTrip(currentTripItem.id)
            action.onNext(.deleteTrip(deleteTripResult))
        }
    }
}
