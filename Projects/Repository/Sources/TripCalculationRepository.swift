//
//  TripCalculationRepository.swift
//  Repository
//
//  Created by Hoyoung Lee on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity

public protocol TripCalculationRepositoryInterface {
    func getBudget(tripId: Int) async throws -> Budgets
}

final public class TripCalculationRepository: TripCalculationRepositoryInterface {

    public init() {}

    let provider = MoyaProvider<TripCalculationService>(plugins: [NetworkLogger()])

    public func getBudget(tripId: Int) async throws -> Budgets {
         let result = await provider.request(
            .getBudget(tripId: tripId)
        )
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case let .failure(error):
            throw error
        }
    }

    public func getCalculation(tripId: Int) async throws -> Calculations {
         let result = await provider.request(
            .calculation(tripId: tripId)
        )
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case let .failure(error):
            throw error
        }
    }
}
