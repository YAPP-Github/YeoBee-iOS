//
//  SettingCurrencyReactor.swift
//  Setting
//
//  Created by 박현준 on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import UseCase
import ComposableArchitecture
import TravelRegistration
import Entity
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingCurrencyReactor: Reactor {
    
    public enum Action {
        case textFieldText(text: String)
        case modified(Bool)
    }
    
    public enum Mutation {
        case textFieldText(text: String)
        case modified(Bool)
    }
    
    public struct State {
        var textFieldText: String = ""
        var currency: Currency
        var tripItem: TripItem
        var isModifyButtonValid: Bool = false
        var isModified: Bool = false
    }
    
    @Dependency(\.currencyUseCase) var currencyUseCase
    public var initialState: State
    
    public init(currency: Currency, tripItem: TripItem) {
        self.initialState = State(currency: currency, tripItem: tripItem)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textFieldText(text: let text):
            return .just(.textFieldText(text: text))
        case .modified(let isSuccess):
            return .just(.modified(isSuccess))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .textFieldText(text: let text):
            if isValidDouble(text) {
                newState.isModifyButtonValid = true
            } else {
                newState.isModifyButtonValid = false
            }
            newState.textFieldText = text
        case .modified(let isSuccess):
            newState.isModified = isSuccess
        }
        
        return newState
    }
    
    func putCurrencyUseCase() {
        Task {
            do {
                let currencyResult = try await currencyUseCase.putTripCurrencies(
                    currentState.tripItem.id,
                    currentState.currency.code,
                    ExchangeRate(value: Double(currentState.textFieldText) ?? 0, standard: currentState.currency.exchangeRate.standard)
                )
                print("currencyResult: \(currencyResult)")
                action.onNext(.modified(currencyResult))
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    private func isValidDouble(_ input: String) -> Bool {
        if input.isEmpty {
            return false
        }
        
        // 문자열에서 숫자와 소수점 외의 문자를 제거한 새 문자열
        let cleanedString = input.filter { "0123456789.".contains($0) }
        
        // 소수점이 두 번 이상 나오는 경우 false 반환
        if cleanedString.filter({ $0 == "." }).count > 1 {
            return false
        }
        
        // 문자열이 소수점으로 시작하거나 끝나면 false 반환
        if cleanedString.first == "." || cleanedString.last == "." {
            return false
        }
        
        return Double(cleanedString) != nil
    }
}
