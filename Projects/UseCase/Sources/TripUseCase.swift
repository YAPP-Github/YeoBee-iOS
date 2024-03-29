//
//  TripUseCase.swift
//  UseCase
//
//  Created by 박현준 on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

import Repository
import Entity
import ComposableArchitecture

public struct TripUseCase {
    public var getTrip: @Sendable (_ tripId: Int) async throws -> TripItem
    public var putTrip: @Sendable (
        _ tripId: Int,
        _ title: String,
        _ startDate: String,
        _ endDate: String,
        _ tripUserList: [ModifyTripUserItemRequest]
    ) async throws -> TripItem
    public var getPastTrip: @Sendable (_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    public var getPresentTrip: @Sendable (_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    public var getFutureTrip: @Sendable (_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    public var checkDateOverlap: @Sendable (_ startDate: String, _ endDate: String) async throws -> TripDateValidationResponse
    public var deleteTrip: @Sendable (_ tripId: Int) async throws -> Bool
    public var postTrip: @Sendable (
        _ title: String,
        _ startDate: String,
        _ endDate: String,
        _ countryList: [CountryItemRequest],
        _ tripUserList: [TripUserItemRequest]
    ) async throws -> TripItem
}

extension TripUseCase: TestDependencyKey {
    public static let testValue: Self = unimplemented()
}

extension DependencyValues {
    public var tripUseCase: TripUseCase {
        get { self[TripUseCase.self] }
        set { self[TripUseCase.self] = newValue }
    }
}

extension TripUseCase: DependencyKey {
    public static var liveValue: TripUseCase {
        let tripRepository = TripRepository()
        return .init(getTrip: { tripId in
            return try await tripRepository.getTrip(tripId)
        }, putTrip: { tripId, title, startDate, endDate, tripUserList in
            return try await tripRepository.putTrip(tripId, title, startDate, endDate, tripUserList)
        }, getPastTrip: { pageIndex, pageSize in
            return try await tripRepository.getPastTrip(pageIndex, pageSize)
        }, getPresentTrip: { pageIndex, pageSize in
            return try await tripRepository.getPresentTrip(pageIndex, pageSize)
        }, getFutureTrip: { pageIndex, pageSize in
            return try await tripRepository.getFutureTrip(pageIndex, pageSize)
        }, checkDateOverlap: { startDate, endDate in
            return try await tripRepository.checkDateOverlap(startDate, endDate)
        }, deleteTrip: { tripId in
            return try await tripRepository.deleteTrip(tripId)
        }, postTrip: { title, startDate, endDate, countryList, tripUserList in
            return try await tripRepository.postTrip(title, startDate, endDate, countryList, tripUserList)
        })
    }
}
