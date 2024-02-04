//
//  HomeReactor.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

public final class HomeReactor: Reactor {
    
    public enum Action {
        case travelingTrip([Trip])
        case comingTrip([Trip])
        case passedTrip([Trip])
    }
    
    public enum Mutation {
        case travelingTrip([Trip])
        case comingTrip([Trip])
        case passedTrip([Trip])
    }
    
    public struct State {
        var travelingTrip: [Trip] = []
        var comingTrip: [Trip] = []
        var passedTrip: [Trip] = []
    }
    
    public var initialState: State = State()
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .travelingTrip(let travelingTrip):
            return .just(.travelingTrip(travelingTrip))
        case .comingTrip(let comingTrip):
            return .just(.comingTrip(comingTrip))
        case .passedTrip(let passedTrip):
            return .just(.passedTrip(passedTrip))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .travelingTrip(let trips):
            newState.travelingTrip = trips
        case .comingTrip(let trips):
            newState.comingTrip = trips
        case .passedTrip(let trips):
            newState.passedTrip = trips
        }
        
        return newState
    }
    
    func homeTripUseCase() {
        let travelingTrip: [Trip] = TripDummy.traveling.getTrips()
        let comingTrip: [Trip] = TripDummy.coming.getTrips()
        let passedTrip: [Trip] = TripDummy.passed.getTrips()
        
        self.action.onNext(.travelingTrip(travelingTrip))
        self.action.onNext(.comingTrip(comingTrip))
        self.action.onNext(.passedTrip(passedTrip))
    }
}
