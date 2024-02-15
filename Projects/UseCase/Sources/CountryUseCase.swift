//
//  CountryUseCase.swift
//  UseCase
//
//  Created by 박현준 on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

import Repository
import Entity
import ComposableArchitecture

public struct CountryUseCase {
    public var getCountries: @Sendable () async throws -> CountryListResponse
}

extension CountryUseCase: TestDependencyKey {
    public static let testValue: Self = unimplemented()
}

extension DependencyValues {
    public var countryUseCase: CountryUseCase {
        get { self[CountryUseCase.self] }
        set { self[CountryUseCase.self] = newValue }
    }
}

extension CountryUseCase: DependencyKey {
    public static var liveValue: CountryUseCase {
        let countryRepository = CountryRepository()
        
        return .init(getCountries: {
            return try await countryRepository.getCountries()
        })
    }
}
