//
//  TripDateItemReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct TripDateItemReducer: Reducer {
    public struct State: Equatable, Identifiable {
        public var id: TimeInterval { date.timeIntervalSince1970 }
        let index: Int
        var isSelected: Bool
        var week: String
        var day: Int
        var date: Date


        init(isSelected: Bool, date: Date, index: Int) {
            self.isSelected = isSelected
            self.date = date
            self.index = index

            let calendar = Calendar.current
            let dayNumber = calendar.component(.weekday, from: date)
            let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
            self.week = daysOfWeek[dayNumber - 1]
            self.day = calendar.component(.day, from: date)
        }
    }

    public enum Action {
        case tappedItem
        case tappedTripReadyButton
    }
    
    public var body: some ReducerOf<TripDateItemReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
