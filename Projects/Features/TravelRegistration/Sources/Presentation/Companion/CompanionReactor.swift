//
//  CompanionReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

public final class CompanionReactor: Reactor {
    
    public enum Action {
        case companionType(CompanionType)
        case addCompanion
        case deleteCompanion(Companion)
    }
    
    public enum Mutation {
        case companionType(CompanionType)
        case addCompanion
        case deleteCompanion(Companion)
    }
    
    public struct State {
        var companionType: CompanionType = .none
        var companions: [Companion] = []
    }
    
    public var initialState: State = State()
    
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .companionType(let type):
            return .just(.companionType(type))
        case .addCompanion:
            return .just(.addCompanion)
        case .deleteCompanion(let companion):
            return .just(.deleteCompanion(companion))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        switch mutation {
        case .companionType(let type):
            newState.companionType = type
        case .addCompanion:
            if newState.companions.count >= 9 {
                print("9명 이상 안되는 토스트 실행")
                break
            }
            newState.companions.append(.init(name: "사용자\(state.companions.count+1)", imageURL: ""))
        case .deleteCompanion(let companion):
            if let companionsIndex = newState.companions.firstIndex(where: { $0 == companion }) {
                newState.companions.remove(at: companionsIndex)
            }
        }
        
        return newState
    }
}
