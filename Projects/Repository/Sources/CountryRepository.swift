//
//  CountryRepository.swift
//  Repository
//
//  Created by 박현준 on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity

public protocol CountryRepositoryInterface {
    func getCountries() async throws -> CountryListResponse
}

final public class CountryRepository: CountryRepositoryInterface {

    public init() {}

    let provider = MoyaProvider<CountryService>(plugins: [NetworkLogger()])

    public func getCountries() async throws -> CountryListResponse {
        let result = await provider.request(.getCountries)
        
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
}
