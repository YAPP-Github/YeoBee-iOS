//
//  SettingReactor.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import TravelRegistration
import Entity
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingReactor: Reactor {
    
    public enum Action {
        case companions([Companion])
        case currencies([SettingCurrency])
    }
    
    public enum Mutation {
        case companions([Companion])
        case currencies([SettingCurrency])
    }
    
    public struct State {
        var companions: [Companion] = []
        var currencies: [SettingCurrency] = []
    }
    
    public var initialState: State = State()
    
    public init() {
        
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .companions(let companions):
            return .just(.companions(companions))
        case .currencies(let currencies):
            return .just(.currencies(currencies))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .companions(let companions):
            newState.companions.append(contentsOf: companions)
        case .currencies(let currencies):
            newState.currencies.append(contentsOf: currencies)
        }
        
        return newState
    }
    
    func settingUseCase() {
        let companions: [Companion] = [
            Companion(uuid: UUID(), name: "짱구", imageUrl: "Image1"),
            Companion(uuid: UUID(), name: "제리", imageUrl: "Image2"),
            Companion(uuid: UUID(), name: "태태", imageUrl: "Image3"),
            Companion(uuid: UUID(), name: "제로", imageUrl: "Image4")
        ]
        
        let currencies: [SettingCurrency] = [
            SettingCurrency(code: "JPY", value: 914),
            SettingCurrency(code: "EUR", value: 914),
            SettingCurrency(code: "CHF", value: 232),
            SettingCurrency(code: "a1dsa", value: 914),
            SettingCurrency(code: "dsbWd", value: 914),
            SettingCurrency(code: "CsdHF", value: 232),
            SettingCurrency(code: "JedsdsPY", value: 914),
            SettingCurrency(code: "EwdUR", value: 914),
            SettingCurrency(code: "CdqssHF", value: 232),
            SettingCurrency(code: "JwPsY", value: 914),
            SettingCurrency(code: "EURsd", value: 914),
            SettingCurrency(code: "CsdsHF", value: 232),
            SettingCurrency(code: "JdqwPY", value: 914),
            SettingCurrency(code: "EsvaUR", value: 914),
            SettingCurrency(code: "CdHsdF", value: 232)
        ]
        
        action.onNext(.companions(companions))
        action.onNext(.currencies(currencies))
    }
}
