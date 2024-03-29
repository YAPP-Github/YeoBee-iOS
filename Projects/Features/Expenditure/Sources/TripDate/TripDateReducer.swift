//
//  TripDateReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct TripDateReducer: Reducer {
    public struct State: Equatable {
        var tripDateItems: IdentifiedArrayOf<TripDateItemReducer.State> = []
        var dates: [Date] = []
        var readyDate: Date
        var selectedDate: Date?

        init(startDate: Date, endDate: Date) {
            readyDate = Calendar.current.date(byAdding: .day, value: -1, to: startDate) ?? Date()
            let dates = datesBetween(startDate: startDate, endDate: endDate)
            self.dates = dates
            dates.enumerated().forEach { index, date in
                tripDateItems.updateOrAppend(.init(isSelected: index == 0, date: date))
            }
        }
    }

    public enum Action {
        case tripDateItem(id: TripDateItemReducer.State.ID, action: TripDateItemReducer.Action)
        case tappedTripReadyButton
        case selectDate(Date?)
    }

    public var body: some ReducerOf<TripDateReducer> {
        Reduce { state, action in
            switch action {
            case let .tripDateItem(id: id, action: .tappedItem):
                let selectedDate = state.tripDateItems[id: id]?.date
                return .send(.selectDate(selectedDate))
            case .tappedTripReadyButton:
                return .send(.selectDate(nil))

            case let .selectDate(selectedDate):
                state.selectedDate = selectedDate
                state.tripDateItems.removeAll()
                state.dates.forEach { date in
                    if let selectedDate {
                        let convertedDate = payedAtDateFormatter.string(from: date)
                        let convertedSelectedDate = payedAtDateFormatter.string(from: selectedDate)
                        state.tripDateItems.updateOrAppend(.init(
                            isSelected: convertedDate == convertedSelectedDate,
                            date: date
                        ))
                    } else {
                        state.tripDateItems.updateOrAppend(.init(isSelected: false, date: date))
                    }
                }
                return .none
            }
        }
        .forEach(\.tripDateItems, action: /Action.tripDateItem) {
            TripDateItemReducer()
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
