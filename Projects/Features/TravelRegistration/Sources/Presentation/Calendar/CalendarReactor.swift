//
//  CalendarReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

public final class CalendarReactor: Reactor {
    
    public enum Action {
        case startDate(date: Date?)
        case endDate(date: Date?)
        case selectedDate(dates: [Date])
    }
    
    public enum Mutation {
        case startDate(date: Date?)
        case endDate(date: Date?)
        case selectedDate(dates: [Date])
    }
    
    public struct State {
        var startDate: Date? = nil
        var endDate: Date? = nil
        var selectedDate: [Date] = []
    }
    
    public var initialState: State = State()
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startDate(date: let date):
            return .just(Mutation.startDate(date: date ?? nil))
        case .endDate(date: let date):
            return .just(Mutation.endDate(date: date ?? nil))
        case .selectedDate(dates: let dates):
            return .just(Mutation.selectedDate(dates: dates))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
    
        switch mutation {
        case .startDate(date: let date):
            newState.startDate = date
            if let date = date {
                newState.selectedDate.append(date)
            } else {
                newState.selectedDate.removeAll()
            }
        case .endDate(date: let date):
            newState.endDate = date
        case .selectedDate(dates: let dates):
            newState.selectedDate.append(contentsOf: dates)
        }
        
        return newState
    }
}
