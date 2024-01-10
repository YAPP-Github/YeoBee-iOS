//
//  AuthRepository.swift
//  Network
//
//  Created by 태태's MacBook on 1/2/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

protocol AuthRepositoryInterface {
    func loginWithKakao(token: String)
    func loginWithApple()
    func logout()
}

class AuthRepository: AuthRepositoryInterface {
    let provider = MoyaProvider<AuthService>()
    
    func loginWithKakao(token: String) {
        provider.request(.kakaoLogin(token: token)) { result in
            // 세부구현
        }
    }
    
    func loginWithApple() {
        // apple login
    }
    
    func logout() {
        // logout 기능
    }
    
    
}
