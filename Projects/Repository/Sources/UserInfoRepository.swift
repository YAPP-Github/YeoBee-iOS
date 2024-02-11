//
//  UserInfoInterface.swift
//  Repository
//
//  Created by 김태형 on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity

public protocol UserInfoInterface {
    func updateUserInfo(request: UpdateUserInfoRequest) async throws -> UpdateUserInfoResponse
    func updateUserState(request: UpdateUserStateRequest) async throws -> UpdateUserStateResponse
    func fetchUserInfo() async throws -> FetchUserResponse
}

final public class UserInfoRepository: UserInfoInterface {
    public init() {}
    
    let provider = MoyaProvider<UserInfoService>(plugins: [NetworkLogger()])
    
    public func updateUserInfo(request: UpdateUserInfoRequest) async throws -> UpdateUserInfoResponse {
        let result = await provider.request(
            .updateInfo(
                nickname: request.nickname,
                profileImageURL: request.profileImageUrl
            )
        )
        switch result {
            case let .success(response):
                return try decode(data: response.data)
            case .failure(let failure):
                throw failure
        }
    }
    
    public func updateUserState(request: UpdateUserStateRequest) async throws -> UpdateUserStateResponse {
        let result = await provider.request(
            .updateState(
                state: request.userState.rawValue
            )
        )
        switch result {
            case let .success(response):
                return try decode(data: response.data)
            case .failure(let failure):
                throw failure
        }
    }
    
    public func fetchUserInfo() async throws -> FetchUserResponse {
        let result = await provider.request(.fetchInfo)
        switch result {
            case let .success(response):
                return try decode(data: response.data)
            case .failure(let failure):
                throw failure
        }
    }
}
