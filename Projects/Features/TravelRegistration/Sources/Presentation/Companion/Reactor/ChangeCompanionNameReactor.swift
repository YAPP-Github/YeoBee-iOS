//
//  ChangeCompanionNameReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

public final class ChangeCompanionNameReactor: Reactor {
    
    public enum Action {
        case nameTextFieldText(text: String)
    }
    
    public enum Mutation {
        case nameTextFieldText(text: String)
    }
    
    public struct State {
        var companion: Companion
        var index: IndexPath
        var effectivenessType: EffectivenessType = .none
        var limitedString: String = ""
    }
    
    public let initialState: State
    
    init(companion: Companion, index: IndexPath) {
        self.initialState = .init(companion: companion, index: index)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nameTextFieldText(let text):
            return .just(.nameTextFieldText(text: text))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        switch mutation {
        case .nameTextFieldText(text: let text):
            let limitedString = textFieldLimitedString(text: text)
            newState.limitedString = limitedString
            
            if containsSpecialCharacters(limitedString) {
                newState.effectivenessType = .containSpecialCharacters
            } else if !isValidName(limitedString) {
                newState.effectivenessType = .notValid
            } else if limitedString.isEmpty {
                newState.effectivenessType = .none
            } else {
                newState.effectivenessType = .valid
            }
        }
        
        return newState
    }
    
    private func isValidName(_ text: String) -> Bool {
        // 한글/영문 포함 5자
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z가-힣]{0,5}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }

    private func containsSpecialCharacters(_ text: String) -> Bool {
        // 특수 문자 포함 확인
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_-+=[]{}|;:'\",.<>?/~`")
        return text.rangeOfCharacter(from: specialCharacterSet) != nil
    }
    
    private func textFieldLimitedString(text: String) -> String {
        if text.count > 5 {
            return String(text.prefix(5))
        } else {
            return text
        }
    }
}
