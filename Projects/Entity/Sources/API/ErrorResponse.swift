//
//  ErrorResponse.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 에러 응답 본문
struct ErrorResponse: Codable {
    var code: String
    var message: String
}
