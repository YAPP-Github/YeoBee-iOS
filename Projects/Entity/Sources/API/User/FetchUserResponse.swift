//
//  FetchUserResponse.swift
//  Entity
//
//  Created by 태태's MacBook on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct FetchUserResponse: Codable {
    public var id: Int
    public var nickname: String
    public var profileImage: String
    public var authProvider: AuthProviderType
    public var userState: UserState
}
