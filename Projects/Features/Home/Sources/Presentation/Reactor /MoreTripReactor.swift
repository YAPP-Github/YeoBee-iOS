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
import ComposableArchitecture
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
    
    @Dependency(\.tripUseCase) var tripUseCase
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

                self.action.onNext(.trips(trips))
            }
        case .coming:
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
                
                self.action.onNext(.trips(trips))
            }
        case .passed:
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

                self.action.onNext(.trips(trips))
            }
        }
    }
}
