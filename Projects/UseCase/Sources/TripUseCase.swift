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
    public var getPastTrip: @Sendable (_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    public var getPresentTrip: @Sendable (_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    public var getFutureTrip: @Sendable (_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
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
        }, getPastTrip: { pageIndex, pageSize in
            return try await tripRepository.getPastTrip(pageIndex, pageSize)
        }, getPresentTrip: { pageIndex, pageSize in
            return try await tripRepository.getPresentTrip(pageIndex, pageSize)
        }, getFutureTrip: { pageIndex, pageSize in
            return try await tripRepository.getFutureTrip(pageIndex, pageSize)
        })
    }
}
