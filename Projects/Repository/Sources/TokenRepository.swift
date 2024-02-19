//
//  TokenRepository.swift
//  Repository
//
//  Created by 김태형 on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity

final public class TokenRepository {
    
    private init() {}
    
    public static let shared = TokenRepository()
    
    let provider = MoyaProvider<TokenService>(plugins: [NetworkLogger()])
    let keychainManager = KeychainManager.shared
    
    public func refresh(token: String) async throws -> Void {
        let response = try await provider.request(.refresh(token: token)).get()
        let authTokenResponse = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
        
        keychainManager.add(key: KeychainManager.accessToken, value: authTokenResponse.accessToken)
        keychainManager.add(key: KeychainManager.refreshToken, value: authTokenResponse.refreshToken)
    }
    
    public func extractExpiredTime(token: String) -> TimeInterval? {
        let tokenString = token.components(separatedBy: ".")
        guard tokenString.count >= 2 else { return nil }
        
        let toDecode = tokenString[1]
        
        var stringToDecode: String = toDecode.replacingOccurrences(of: "-", with: "+")
        stringToDecode = stringToDecode.replacingOccurrences(of: "_", with: "/")
        switch stringToDecode.utf16.count % 4 {
            case 2: stringToDecode = "\(stringToDecode)=="
            case 3: stringToDecode = "\(stringToDecode)="
            default: break
        }
        
        guard let dataToDecode = Data(base64Encoded: stringToDecode),
              let decodedString = String(data: dataToDecode, encoding: .utf8),
              let data = decodedString.data(using: .utf8) else { return nil }
        do {
            let tokenClaims = try JSONDecoder().decode(TokenPayload.self, from: data)
            return tokenClaims.exp
        } catch {
            return nil
        }
    }

    public func checkExpirationTime(expirationTime: TimeInterval) -> Bool {
        let currentTime = Date().timeIntervalSince1970
        let timeLeft = expirationTime - currentTime
        
        return timeLeft >= 300
    }
    
    public func isTokenExpiring() async throws -> Bool {
        guard let accessToken = keychainManager.load(key: KeychainManager.accessToken),
              let refreshToken = keychainManager.load(key: KeychainManager.accessToken) else {
            return false
        }
        
        let accessTokenExp = extractExpiredTime(token: accessToken)
        let refreshTokenExp = extractExpiredTime(token: refreshToken)
        
        // 액세스 토큰이 만료되었는지 검사
        if let accessTokenExp = accessTokenExp, checkExpirationTime(expirationTime: accessTokenExp) {
            return true
        }
        
        // 리프레시 토큰이 만료되었는지 검사 및 갱신 시도
        else if let refreshTokenExp = refreshTokenExp, checkExpirationTime(expirationTime: refreshTokenExp) {
            try await refresh(token: keychainManager.load(key: KeychainManager.refreshToken)!)
            return true
        }
        
        // 두 토큰이 모두 유효하지 않은 경우 삭제
        deleteTokens()
        return false
    }
    
    public func deleteTokens() {
        keychainManager.delete(key: KeychainManager.accessToken)
        keychainManager.delete(key: KeychainManager.refreshToken)
    }
}

struct TokenPayload: Codable {
    let sub: String
    let exp: TimeInterval
}
