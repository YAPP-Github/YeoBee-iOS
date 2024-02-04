//
//  MoreTripReactor.swift
//  Home
//
//  Created by 박현준 on 1/30/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import ReactorKit
import RxSwift
import RxCocoa

public final class MoreTripReactor: Reactor {
    
    public enum Action {
        case trips([Trip])
    }
    
    public enum Mutation {
        case trips([Trip])
    }
    
    public struct State {
        var trips: [Trip] = []
        var tripType: TripType
    }
    
    public var initialState: State
    
    init(tripType: TripType) {
        self.initialState = State(tripType: tripType)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .trips(let trips):
            return .just(.trips(trips))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .trips(let trips):
            newState.trips = trips
        }
        
        return newState
    }
    
    func moreTripUseCase() {
        switch currentState.tripType {
        case .traveling:
            let travelingTrip: [Trip] = TripDummy.traveling.getTrips()
            action.onNext(.trips(travelingTrip))
        case .coming:
            let comingTrip: [Trip] = TripDummy.coming.getTrips()
            action.onNext(.trips(comingTrip))
        case .passed:
            let passedTrip: [Trip] = TripDummy.passed.getTrips()
            action.onNext(.trips(passedTrip))
        }
    }
}
