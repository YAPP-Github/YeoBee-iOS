//
//  CalendarReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import UseCase
import ComposableArchitecture
import ReactorKit
import RxSwift
import RxCocoa

public final class CalendarReactor: Reactor {
    
    public enum Action {
        case startDate(date: Date?)
        case endDate(date: Date?)
        case selectedDate(dates: [Date])
        case checkedDateValidation(isOverlap: Bool)
    }
    
    public enum Mutation {
        case startDate(date: Date?)
        case endDate(date: Date?)
        case selectedDate(dates: [Date])
        case checkedDateValidation(isOverlap: Bool)
    }
    
    public struct State {
        var startDate: Date? = nil
        var endDate: Date? = nil
        var selectedDate: [Date] = []
        var tripRequest: RegistTripRequest
        var checkedDateValidation: Bool = false
    }
    
    @Dependency(\.tripUseCase) var tripUseCase
    public var initialState: State
    
    init(tripRequest: RegistTripRequest) {
        self.initialState = State(tripRequest: tripRequest)
    }
    
    func checkDateValidationUseCase(_ startDate: String, _ endDate: String) {
        Task {
            let result = try await tripUseCase.checkDateOverlap(startDate, endDate)
            action.onNext(.checkedDateValidation(isOverlap: result.overlap))
        }
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startDate(date: let date):
            return .just(Mutation.startDate(date: date ?? nil))
        case .endDate(date: let date):
            return .just(Mutation.endDate(date: date ?? nil))
        case .selectedDate(dates: let dates):
            return .just(Mutation.selectedDate(dates: dates))
        case .checkedDateValidation(isOverlap: let isOverlap):
            return .just(.checkedDateValidation(isOverlap: isOverlap))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .startDate(date: let date):
            newState.checkedDateValidation = false
            newState.startDate = date
            if let date = date {
                newState.selectedDate.append(date)
            } else {
                newState.selectedDate.removeAll()
            }
        case .endDate(date: let date):
            newState.endDate = date
        
            if let startDate = state.startDate, let endDate = date {
                let startDateString = formatDateToString(startDate)
                let endDateString = formatDateToString(endDate)
                checkDateValidationUseCase(startDateString, endDateString)
            } else {
                newState.checkedDateValidation = false
            }
        case .selectedDate(dates: let dates):
            newState.selectedDate.append(contentsOf: dates)
        case .checkedDateValidation(isOverlap: let isOverlap):
            newState.checkedDateValidation = isOverlap
        }
        
        return newState
    }
    
    func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
