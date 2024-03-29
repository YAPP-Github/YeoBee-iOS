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

public protocol TripRepositoryInterface {
    func getTrip(_ tripId: Int) async throws -> TripItem
    func putTrip(
        _ tripId: Int,
        _ title: String,
        _ startDate: String,
        _ endDate: String,
        _ tripUserList: [ModifyTripUserItemRequest]
    ) async throws -> TripItem
    func getPastTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    func getPresentTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    func getFutureTrip(_ pageIndex: Int, _ pageSize: Int) async throws -> TripResponse
    func checkDateOverlap(_ startDate: String, _ endDate: String) async throws -> TripDateValidationResponse
    func deleteTrip(_ tripId: Int) async throws -> Bool
    func postTrip(
        _ title: String,
        _ startDate: String,
        _ endDate: String,
        _ countryList: [CountryItemRequest],
        _ tripUserList: [TripUserItemRequest]
    ) async throws -> TripItem
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
    
    public func putTrip(_ tripId: Int, _ title: String, _ startDate: String, _ endDate: String, _ tripUserList: [ModifyTripUserItemRequest]) async throws -> TripItem {
        let result = await provider.request(.putTrip(tripId, title, startDate, endDate, tripUserList))
        
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
    
    public func checkDateOverlap(_ startDate: String, _ endDate: String) async throws -> TripDateValidationResponse {
        let result = await provider.request(.checkDateOverlap(startDate, endDate))
        
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
    
    public func deleteTrip(_ tripId: Int) async throws -> Bool {
        let result = await provider.request(.deleteTrip(tripId))
        
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func postTrip(
        _ title: String,
        _ startDate: String,
        _ endDate: String,
        _ countryList: [CountryItemRequest],
        _ tripUserList: [TripUserItemRequest]
    ) async throws -> TripItem {
        let result = await provider.request(.postTrip(title, startDate, endDate, countryList, tripUserList))
        
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case .failure(let failure):
            throw failure
        }
    }
}
