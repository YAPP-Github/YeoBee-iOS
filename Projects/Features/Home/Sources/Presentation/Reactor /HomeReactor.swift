//
//  HomeReactor.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import UseCase
import ComposableArchitecture

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
    
    @Dependency(\.tripUseCase) var tripUseCase
    public var initialState: State
    
    public init() {
        self.initialState = State()
    }
    
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
        Task {
            let pastResult = try await tripUseCase.getPastTrip(0, 1)
            
            let trips = pastResult.content.compactMap { content in
                Trip(
                    countries: content.countryList.compactMap { $0.name },
                    coverImageURL: content.countryList.first?.coverImageUrl ?? "",
                    flagImageURL: content.countryList.first?.flagImageUrl ?? "",
                    title: content.title,
                    startDate: content.startDate,
                    endDate: content.endDate
                )
            }

            self.action.onNext(.passedTrip(trips))
        }
        
        Task {
            let presentResult = try await tripUseCase.getPresentTrip(0, 1)
            
            let trips = presentResult.content.compactMap { content in
                Trip(
                    countries: content.countryList.compactMap { $0.name },
                    coverImageURL: content.countryList.first?.coverImageUrl ?? "",
                    flagImageURL: content.countryList.first?.flagImageUrl ?? "",
                    title: content.title,
                    startDate: content.startDate,
                    endDate: content.endDate
                )
            }

            self.action.onNext(.travelingTrip(trips))
        }
        
        Task {
            let futureResult = try await tripUseCase.getFutureTrip(0, 1)
            
            let trips = futureResult.content.compactMap { content in
                Trip(
                    countries: content.countryList.compactMap { $0.name },
                    coverImageURL: content.countryList.first?.coverImageUrl ?? "",
                    flagImageURL: content.countryList.first?.flagImageUrl ?? "",
                    title: content.title,
                    startDate: content.startDate,
                    endDate: content.endDate
                )
            }
            
            self.action.onNext(.comingTrip(trips))
        }
    }
}
