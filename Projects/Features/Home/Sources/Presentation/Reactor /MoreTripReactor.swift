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
        case trips([TripItem])
        case totalPage(Int)
        case pageNumber(Int)
        case isLoading(Bool)
    }
    
    public enum Mutation {
        case trips([TripItem])
        case totalPage(Int)
        case pageNumber(Int)
        case isLoading(Bool)
    }
    
    public struct State {
        var trips: [TripItem] = []
        var tripType: TripType
        var totalPage: Int = 0
        var pageNumber: Int = 0
        var isLoading: Bool = false
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
        case .totalPage(let totalPage):
            return .just(.totalPage(totalPage))
        case .pageNumber(let pageNumber):
            return .just(.pageNumber(pageNumber))
        case .isLoading(let isLoading):
            return .just(.isLoading(isLoading))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .trips(let trips):
            newState.trips = trips
        case .totalPage(let totalPage):
            newState.totalPage = totalPage
        case .pageNumber(let pageNumber):
            newState.pageNumber = pageNumber
        case .isLoading(let isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
    
    private func handleTripResponse(result: TripResponse, pageNumber: Int) {
        var currentTripItems = currentState.trips
        currentTripItems.append(contentsOf: result.content)
        action.onNext(.trips(currentTripItems))
        action.onNext(.pageNumber(pageNumber))
        action.onNext(.isLoading(false))
    }
    
    func moreTripUseCase() {
        switch currentState.tripType {
        case .traveling:
            Task {
                let presentResult = try await tripUseCase.getPresentTrip(0, 5)
                action.onNext(.totalPage(presentResult.totalPages))
                handleTripResponse(result: presentResult, pageNumber: presentResult.pageable.pageNumber)
            }
        case .coming:
            Task {
                let futureResult = try await tripUseCase.getFutureTrip(0, 5)
                action.onNext(.totalPage(futureResult.totalPages))
                handleTripResponse(result: futureResult, pageNumber: futureResult.pageable.pageNumber)
            }
        case .passed:
            Task {
                let pastResult = try await tripUseCase.getPastTrip(0, 5)
                action.onNext(.totalPage(pastResult.totalPages))
                handleTripResponse(result: pastResult, pageNumber: pastResult.pageable.pageNumber)
            }
        }
    }
    
    func loadNextPageIfNeeded() {
        if !currentState.isLoading && currentState.pageNumber < currentState.totalPage {
            self.action.onNext(.isLoading(true))
            updateMoreTripUseCase(pageNumber: currentState.pageNumber + 1)
        }
    }

    private func updateMoreTripUseCase(pageNumber: Int) {
        self.action.onNext(.pageNumber(pageNumber))
        
        switch currentState.tripType {
        case .traveling:
            Task {
                let presentResult = try await tripUseCase.getPresentTrip(pageNumber, 5)
                handleTripResponse(result: presentResult, pageNumber: presentResult.pageable.pageNumber)
            }
        case .coming:
            Task {
                let futureResult = try await tripUseCase.getFutureTrip(pageNumber, 5)
                handleTripResponse(result: futureResult, pageNumber: futureResult.pageable.pageNumber)
            }
        case .passed:
            Task {
                let pastResult = try await tripUseCase.getPastTrip(pageNumber, 5)
                handleTripResponse(result: pastResult, pageNumber: pastResult.pageable.pageNumber)
            }
        }
    }
}
