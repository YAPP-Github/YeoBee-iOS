//
//  SettingCalendarReactor.swift
//  Setting
//
//  Created by 박현준 on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import UseCase
import ComposableArchitecture
import ReactorKit
import RxSwift
import RxCocoa

public final class SettingCalendarReactor: Reactor {
    
    public enum Action {
        case startDate(date: Date?)
        case endDate(date: Date?)
        case selectedDate(dates: [Date])
        case modified(Bool)
    }
    
    public enum Mutation {
        case startDate(date: Date?)
        case endDate(date: Date?)
        case selectedDate(dates: [Date])
        case modified(Bool)
    }
    
    public struct State {
        var startDate: Date? = nil
        var endDate: Date? = nil
        var selectedDate: [Date] = []
        var tripItem: TripItem
        var modified: Bool = false
    }
    
    @Dependency(\.tripUseCase) var tripUseCase
    public var initialState: State
    
    init(tripItem: TripItem) {
        self.initialState = State(tripItem: tripItem)
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
        case .modified(let isSucess):
            return .just(.modified(isSucess))
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
        case .modified(let isSucess):
            newState.modified = isSucess
        }
        
        return newState
    }
    
    func modifyDaysUseCase() {
        let currentTripItem = currentState.tripItem
        
        Task {
            let tripUserRequests = currentTripItem.tripUserList.map { ModifyTripUserItemRequest(id: $0.id, name: $0.name ?? "") }
            if let startDate = currentState.startDate,
               let endDate = currentState.endDate ?? currentState.startDate {
                
                try await tripUseCase.putTrip(
                    currentTripItem.id,
                    currentTripItem.title,
                    formatDateToString(startDate),
                    formatDateToString(endDate),
                    tripUserRequests
                )
                return action.onNext(.modified(true))
            }
        }
    }
    
    func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
