//
//  HomeReactor.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import UseCase
import Entity
import YBNetwork
import ComposableArchitecture

import ReactorKit
import RxSwift
import RxCocoa

public final class HomeReactor: Reactor {
    
    public enum Action {
        case travelingTrip([TripItem])
        case comingTrip([TripItem])
        case passedTrip([TripItem])
        case userInfo(FetchUserResponse)
    }
    
    public enum Mutation {
        case travelingTrip([TripItem])
        case comingTrip([TripItem])
        case passedTrip([TripItem])
        case userInfo(FetchUserResponse)
    }
    
    public struct State {
        var travelingTrip: [TripItem] = []
        var comingTrip: [TripItem] = []
        var passedTrip: [TripItem] = []
        var userInfo: FetchUserResponse? = nil
    }
    
    @Dependency(\.userInfoUseCase) var userInfoUseCase
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
        case .userInfo(let userInfo):
            return .just(.userInfo(userInfo))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .travelingTrip(let tripItems):
            newState.travelingTrip = tripItems
        case .comingTrip(let tripItems):
            newState.comingTrip = tripItems
        case .passedTrip(let tripItems):
            newState.passedTrip = tripItems
        case .userInfo(let userInfo):
            newState.userInfo = userInfo
        }
        
        return newState
    }
    
    func homeInitUseCase() {
        Task {
            let userResult = try await userInfoUseCase.fetchUserInfo()
            self.action.onNext(.userInfo(userResult))
            
            if KeychainManager.shared.load(key: KeychainManager.userId) == nil {
                KeychainManager.shared.add(key: KeychainManager.userId, value: "\(userResult.id)")
            }
        }
        homeTripUseCase()
    }
    
    func homeTripUseCase() {
        Task {
            let pastResult = try await tripUseCase.getPastTrip(0, 3)
            let tripItems = pastResult.content
            self.action.onNext(.passedTrip(tripItems))
        }
        
        Task {
            let presentResult = try await tripUseCase.getPresentTrip(0, 3)
            let tripItems = presentResult.content
            self.action.onNext(.travelingTrip(tripItems))
        }
        
        Task {
            let futureResult = try await tripUseCase.getFutureTrip(0, 3)
            let tripItems = futureResult.content
            self.action.onNext(.comingTrip(tripItems))
        }
    }
}
