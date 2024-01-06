//
//  KakaoLoginRequest.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 서버에 보낼 요청 본문
struct KakaoLoginRequest: Codable {
    var oauthToken: String
}

// 서버 응답 처리를 위한 열거형
enum ServerResponse {
    case success(AuthTokenResponse)
    case failure(ErrorResponse)
}
