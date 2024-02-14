//
//  TripRepository.swift
//  Repository
//
//  Created by 박현준 on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity
import Dependencies

public protocol TripRepositoryInterface {
    func getTrip(_ tripId: Int) async throws -> TripItem
    func getPastTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    func getPresentTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    func getFutureTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
}

final public class TripRepository: TripRepositoryInterface {

    public init() {}

    let provider = MoyaProvider<TripService>(plugins: [NetworkLogger()])

    public func getTrip(_ tripId: Int) async throws -> TripItem {
        let result = await provider.request(.getTrip(tripId))
        
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
    
    public func getPastTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse {
        let result = await provider.request(.getPastTrip(pageIndex, pageSize))
        
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
    
    public func getPresentTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse {
        let result = await provider.request(.getPresentTrip(pageIndex, pageSize))
        
        switch result {
        case .success(let response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
    
    public func getFutureTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse {
        let result = await provider.request(.getFutureTrip(pageIndex, pageSize))
        
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
    
}