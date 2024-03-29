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
import UseCase
import ComposableArchitecture
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingRecycleReactor: Reactor {
    
    public enum Action {
        case textFieldText(text: String)
        case modified(Bool)
    }
    
    public enum Mutation {
        case textFieldText(text: String)
        case modified(Bool)
    }
    
    public struct State {
        var viewType: SettingRecycleType
        var limitedString = ""
        var effectivenessType: EffectivenessType = .none
        var tripItem: TripItem
        var tripUserItem: TripUserItem?
        var modified: Bool = false
    }
    
    @Dependency(\.tripUseCase) var tripUseCase
    public var initialState: State
    
    public init(viewType: SettingRecycleType, tripItem: TripItem, tripUserItem: TripUserItem? = nil) {
        self.initialState = State(viewType: viewType, tripItem: tripItem, tripUserItem: tripUserItem)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textFieldText(text: let text):
            return .just(.textFieldText(text: text))
        case .modified(let isSucess):
            return .just(.modified(isSucess))
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
        case .modified(let isSucess):
            newState.modified = isSucess
        }
        
        return newState
    }
    
    func modifyTitleUseCase() {
        let currentTripItem = currentState.tripItem
        
        Task {
            let tripUserRequests = currentTripItem.tripUserList.map { ModifyTripUserItemRequest(id: $0.id, name: $0.name ?? "") }
            try await tripUseCase.putTrip(
                currentTripItem.id,
                currentState.limitedString,
                currentTripItem.startDate,
                currentTripItem.endDate,
                tripUserRequests
            )
            return action.onNext(.modified(true))
        }
    }
    
    func modifyCompanionNameUseCase() {
        var currentTripItem = currentState.tripItem
        guard let currenttripUserItem = currentState.tripUserItem else { return }
        
        // 동행자 배열 안에서 이름 변경
        for index in 0..<currentTripItem.tripUserList.count {
            if currentTripItem.tripUserList[index].id == currenttripUserItem.id {
                currentTripItem.tripUserList[index].name = currentState.limitedString
            }
        }
        
        let modifiedTripItem = currentTripItem
        
        Task {
            let tripUserRequests = modifiedTripItem.tripUserList.map { ModifyTripUserItemRequest(id: $0.id, name: $0.name ?? "") }
            try await tripUseCase.putTrip(
                modifiedTripItem.id,
                modifiedTripItem.title,
                modifiedTripItem.startDate,
                modifiedTripItem.endDate,
                tripUserRequests
            )
            return action.onNext(.modified(true))
        }
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
