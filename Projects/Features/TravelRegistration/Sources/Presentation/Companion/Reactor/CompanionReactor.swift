//
//  CompanionReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import RxSwift
import RxCocoa

public final class CompanionReactor: Reactor {
    
    public enum Action {
        case companionType(CompanionType)
        case addCompanion
        case deleteCompanion(Companion)
        case updateCompanion(Companion, IndexPath)
    }
    
    public enum Mutation {
        case companionType(CompanionType)
        case addCompanion
        case deleteCompanion(Companion)
        case updateCompanion(Companion, IndexPath)
    }
    
    public struct State {
        var companionType: CompanionType = .none
        var companions: [Companion] = []
        var companionNumber: Int = 0
        var makeLimitToast: Bool = false
        var tripRequest: TripRequest
    }
    
    public var initialState: State
    
    init(tripRequest: TripRequest) {
        self.initialState = State(tripRequest: tripRequest)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .companionType(let type):
            return .just(.companionType(type))
        case .addCompanion:
            return .just(.addCompanion)
        case .deleteCompanion(let companion):
            return .just(.deleteCompanion(companion))
        case .updateCompanion(let companion, let index):
            return .just(.updateCompanion(companion, index))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        switch mutation {
        case .companionType(let type):
            if type == .alone {
                newState.makeLimitToast = false
            }
            newState.companionType = type
        case .addCompanion:
            if newState.companions.count >= 9 {
                newState.makeLimitToast = true
                break
            }
            newState.companionNumber += 1
            newState.companions.append(.init(name: "사용자\(newState.companionNumber)", type: getFaceString()))
        case .deleteCompanion(let companion):
            if let companionsIndex = newState.companions.firstIndex(where: { $0 == companion }) {
                newState.companions.remove(at: companionsIndex)
                newState.makeLimitToast = false
            }
        case .updateCompanion(let companion, let index):
            newState.companions[index.row] = companion
        }
        
        return newState
    }
    
    func getFaceString() -> String {
        let existingTypes = currentState.companions.compactMap { $0.type }
        
        var nextNumber = 1
        while existingTypes.contains("Image\(nextNumber)") {
            nextNumber += 1
        }
        
        return "Image\(nextNumber)"
    }
}
