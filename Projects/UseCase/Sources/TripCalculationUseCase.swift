//
//  TripCalculationUseCase.swift
//  UseCase
//
//  Created by Hoyoung Lee on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

import Repository
import Entity
import ComposableArchitecture

public struct TripCalculationUseCase {
    public var getBudget: @Sendable (_ tripId: Int) async throws -> Budgets
    public var getCalculation: @Sendable (_ tripId: Int) async throws -> [Calculation]
}

extension TripCalculationUseCase: TestDependencyKey {
    public static let testValue: Self = unimplemented()
}

extension DependencyValues {
    public var tripCalculationUseCase: TripCalculationUseCase {
        get { self[TripCalculationUseCase.self] }
        set { self[TripCalculationUseCase.self] = newValue }
    }
}

extension TripCalculationUseCase: DependencyKey {
    public static var liveValue: TripCalculationUseCase {
        let tripCalculationRepository = TripCalculationRepository()
        return .init(getBudget: { tripId in
            let data = try await tripCalculationRepository.getBudget(
                tripId: tripId
            )
            return data
        }, getCalculation: { tripId in
            let data = try await tripCalculationRepository.getCalculation(
                tripId: tripId
            )
            return data.calculationList
        }
        )
    }
}

