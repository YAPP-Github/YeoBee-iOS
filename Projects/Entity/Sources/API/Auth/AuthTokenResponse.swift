//
//  AuthResponse.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 성공적인 응답 본문
public struct AuthTokenResponse: Codable {
    public var accessToken: String
    public var refreshToken: String
}
