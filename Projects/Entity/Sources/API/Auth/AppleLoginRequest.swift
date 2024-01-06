//
//  AppleLoginRequest.swift
//  Entity
//
//  Created by 태태's MacBook on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 서버에 보낼 요청 본문
struct AppleLoginRequest: Codable {
    var code: String
    var idToken: String
}
