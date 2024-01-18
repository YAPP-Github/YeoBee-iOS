//
//  CompanionReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
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
        var makeLimitToast: Bool = false
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
        case .updateCompanion(let companion, let index):
            return .just(.updateCompanion(companion, index))
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
                newState.makeLimitToast = true
                break
            }
            newState.companions.append(.init(name: "사용자\(state.companions.count+1)", image: getRandomFaceIcon()))
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
    
    func getRandomFaceIcon() -> UIImage {
        guard let randomImage = [
            DesignSystemAsset.Icons.face2.image,
            DesignSystemAsset.Icons.face3.image,
            DesignSystemAsset.Icons.face4.image,
            DesignSystemAsset.Icons.face5.image,
            DesignSystemAsset.Icons.face6.image,
            DesignSystemAsset.Icons.face7.image,
            DesignSystemAsset.Icons.face8.image,
            DesignSystemAsset.Icons.face9.image
        ].randomElement() else { return DesignSystemAsset.Icons.face1.image }
        
        return randomImage
    }
}
