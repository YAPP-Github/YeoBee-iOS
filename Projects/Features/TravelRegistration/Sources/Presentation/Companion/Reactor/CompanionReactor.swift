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
import YBNetwork
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
        var tripRequest: RegistTripRequest
    }
    
    public var initialState: State
    
    init(tripRequest: RegistTripRequest) {
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
            newState.companions.append(.init(name: "사용자\(newState.companionNumber)", imageUrl: getFaceUrl()))
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
    
    func getFaceUrl() -> String {
        let existingTypes = currentState.companions.compactMap { $0.imageUrl }
        
        var nextNumber = 1
        while existingTypes.contains("\(YeoBeeAPI.shared.baseImageURL ?? "")/static/user/profile/profile\(nextNumber).png") {
            nextNumber += 1
        }
        return "\(YeoBeeAPI.shared.baseImageURL ?? "")/static/user/profile/profile\(nextNumber).png"
    }
}
