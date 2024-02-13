//
//  SettingRecycleReactor.swift
//  Setting
//
//  Created by 박현준 on 2/10/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import TravelRegistration
import Entity
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingRecycleReactor: Reactor {
    
    public enum Action {
        case textFieldText(text: String)
    }
    
    public enum Mutation {
        case textFieldText(text: String)
    }
    
    public struct State {
        var viewType: SettingRecycleType
        var limitedString = ""
        var effectivenessType: EffectivenessType = .none
    }
    
    public var initialState: State
    
    public init(viewType: SettingRecycleType) {
        self.initialState = State(viewType: viewType)
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
            if state.viewType == .tripTitle {
                // 여행 제목 변경
                newState.limitedString = text
                
                if text.isEmpty {
                    newState.effectivenessType = .none
                } else {
                    if isValidTitleText(text) {
                        newState.effectivenessType = .valid
                    } else {
                        newState.effectivenessType = .notValid
                    }
                }
            } else {
                // 동행자 이름 변경
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
        }
        
        return newState
    }
    
    private func isValidName(_ text: String) -> Bool {
        // 한글/영문 포함 5자
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z가-힣]{0,5}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex?.firstMatch(in: text, options: [], range: range) != nil
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
    
    private func isValidTitleText(_ text: String) -> Bool {
        return text.count <= 15
    }
}
