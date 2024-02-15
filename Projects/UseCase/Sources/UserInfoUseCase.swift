//
//  UserInfoUseCase.swift
//  UseCase
//
//  Created by 박현준 on 2/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

import Repository
import Entity
import ComposableArchitecture

public struct UserInfoUseCase {
    public var updateUserInfo: @Sendable (_ request: UpdateUserInfoRequest) async throws -> UpdateUserInfoResponse
    public var updateUserState: @Sendable (_ request: UpdateUserStateRequest) async throws -> UpdateUserStateResponse
    public var fetchUserInfo: @Sendable () async throws -> FetchUserResponse
    
}

extension UserInfoUseCase: TestDependencyKey {
    public static let testValue: Self = unimplemented()
}

extension DependencyValues {
    public var userInfoUseCase: UserInfoUseCase {
        get { self[UserInfoUseCase.self] }
        set { self[UserInfoUseCase.self] = newValue }
    }
}

extension UserInfoUseCase: DependencyKey {
    public static var liveValue: UserInfoUseCase {
        let userInfoRepository = UserInfoRepository()
        return .init(updateUserInfo: { request in
            return try await userInfoRepository.updateUserInfo(request: request)
        }, updateUserState: { request in
            return try await userInfoRepository.updateUserState(request: request)
        }, fetchUserInfo: {
            return try await userInfoRepository.fetchUserInfo()
        })
    }
}
