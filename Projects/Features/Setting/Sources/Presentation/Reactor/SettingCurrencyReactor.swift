//
//  SettingCurrencyReactor.swift
//  Setting
//
//  Created by 박현준 on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import TravelRegistration
import Entity
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingCurrencyReactor: Reactor {
    
    public enum Action {
        case textFieldText(text: String)
    }
    
    public enum Mutation {
        case textFieldText(text: String)
    }
    
    public struct State {
        var textFieldText: String = ""
        var currency: SettingCurrency
    }
    
    public var initialState: State
    
    public init(currency: SettingCurrency) {
        self.initialState = State(currency: currency)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textFieldText(text: let text):
            return .just(.textFieldText(text: text))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .textFieldText(text: let text):
            newState.textFieldText = text
        }
        
        return newState
    }
}
