//
//  TripDateReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct TripDateReducer: Reducer {
    public struct State: Equatable {
        var tripDateItems: IdentifiedArrayOf<TripDateItemReducer.State> = []
        var expenditureListStates: IdentifiedArrayOf<ExpenditureListReducer.State> = []
        var dates: [Date] = []
        var readyDate: Date
        @BindingState var selectedDate: Date

        init(startDate: Date, endDate: Date, type: ExpenditureTab, tripItem: TripItem) {
            readyDate = Calendar.current.date(byAdding: .day, value: -1, to: startDate) ?? Date()
            let selectDate: Date
            let currentDate = Date()
            if currentDate < startDate {
                selectDate = readyDate
            } else if currentDate > endDate {
                selectDate = startDate
            } else {
                selectDate = currentDate
            }
            selectedDate = selectDate
            let dates = datesBetween(startDate: readyDate, endDate: endDate)
            self.dates = dates
            dates.enumerated().forEach { index, date in
                tripDateItems.updateOrAppend(.init(isSelected: index == 0, date: date, index: index))
                expenditureListStates.updateOrAppend(.init(type: type, tripItem: tripItem, date: date))
            }
        }
    }

    public enum Action: BindableAction {
        case tripDateItem(id: TripDateItemReducer.State.ID, action: TripDateItemReducer.Action)
        case expenditureList(id: ExpenditureListReducer.State.ID, action: ExpenditureListReducer.Action)
        case initailDate
        case selectDate(Date)
        case binding(BindingAction<State>)
        case scrollToBottom
    }

    public var body: some ReducerOf<TripDateReducer> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .tripDateItem(id: id, action: .tappedItem):
                if let selectedDate = state.tripDateItems[id: id]?.date {
                    return .send(.selectDate(selectedDate))
                }
                return .none

            case .initailDate:
                return .send(.selectDate(state.selectedDate))

            case let .selectDate(selectedDate):
                state.selectedDate = selectedDate
                state.tripDateItems.removeAll()
                state.dates.enumerated().forEach { index, date in
                    let convertedDate = payedAtDateFormatter.string(from: date)
                    let convertedSelectedDate = payedAtDateFormatter.string(from: selectedDate)
                    state.tripDateItems.updateOrAppend(.init(
                        isSelected: convertedDate == convertedSelectedDate,
                        date: date,
                        index: index
                    ))
                }
                return .send(.expenditureList(id: selectedDate, action: .getExpenditure(true)))

            case .expenditureList:
                return .none

            case .binding(\.$selectedDate):
                state.tripDateItems.removeAll()
                state.dates.enumerated().forEach { index, date in
                    let convertedDate = payedAtDateFormatter.string(from: date)
                    let convertedSelectedDate = payedAtDateFormatter.string(from: state.selectedDate)
                    state.tripDateItems.updateOrAppend(.init(
                        isSelected: convertedDate == convertedSelectedDate,
                        date: date, 
                        index: index
                    ))
                }
                return .send(.expenditureList(id: state.selectedDate, action: .getExpenditure(true)))

            case .binding:
                return .none

            case .scrollToBottom:
                return .send(.expenditureList(id: state.selectedDate, action: .appendExpenditures))

            case .tripDateItem(id: _, action: .tappedTripReadyButton):
                return .send(.selectDate(state.readyDate))
            }
        }
        .forEach(\.tripDateItems, action: /Action.tripDateItem) {
            TripDateItemReducer()
        }
        .forEach(\.expenditureListStates, action: /Action.expenditureList) {
            ExpenditureListReducer()
        }
    }

    var payedAtDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }
}

extension TripDateReducer.State {
    func datesBetween(startDate: Date?, endDate: Date?) -> [Date] {
        guard let startDate = startDate,
              let endDate = endDate else { return [] }
        
        var currentDate = startDate
        var dates: [Date] = []
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return dates
    }
}
