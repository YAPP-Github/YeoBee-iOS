//
//  Trip.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation

enum TripDummy: String, CaseIterable {
    case coming
    case passed
    
    func getTrips() -> [Trip] {
        switch self {
        case .coming:
            return Self.commingTripData
        case .passed:
            return Self.passedTripData
        }
    }
    
    private static let commingTripData: [Trip] = [
        Trip(countries: ["프랑스","대한민국","일본"], imageURL: "abc", title: "유럽 여행기", startDate: "2023년 12월 08일", endDate: "2023년 12월 17일"),
        Trip(countries: ["말레이시아","대만","일본"], imageURL: "abc", title: "말레이시아", startDate: "2023년 11월 09일", endDate: "2023년 11월 17일"),
        Trip(countries: ["일본"], imageURL: "abc", title: "일본여행", startDate: "2023년 10월 05일", endDate: "2023년 10월 08일")
    ]
    
    private static let passedTripData: [Trip] = [
        Trip(countries: ["말레이시아","대만","일본"], imageURL: "abc", title: "말레이시아", startDate: "2023년 11월 09일", endDate: "2023년 11월 17일"),
        Trip(countries: ["일본"], imageURL: "abc", title: "일본여행", startDate: "2023년 10월 05일", endDate: "2023년 10월 08일"),
        Trip(countries: ["프랑스","대한민국","일본"], imageURL: "abc", title: "유럽 여행기", startDate: "2023년 12월 08일", endDate: "2023년 12월 17일")
    ]
}

struct Trip: Hashable, Equatable {
    var countries: [String]
    var imageURL: String
    var title: String
    var startDate: String
    var endDate: String
}
