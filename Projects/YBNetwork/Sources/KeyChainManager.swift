//
//  KeyChainManager.swift
//  YBNetwork
//
//  Created by 김태형 on 2/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

protocol KeychainManagerInterface {
    func add(key: String, value: String) -> Bool
    func load(key: String) -> String?
    func update(key: String, value: String) -> Bool
    func delete(key: String) -> Bool
}

public final class KeychainManager: KeychainManagerInterface {
    
    public enum KeychainError: Error {
        case noData
    }
    
    public static let shared = KeychainManager()
    public static let accessToken: String = "accessToken"
    public static let refreshToken: String = "refreshToken"
    public static let accessTokenExpiredTime: String = "accessTokenExpiredTime"
    public static let refreshTokenExpiredTime: String = "refreshTokenExpiredTime"
    public static let userId: String = "userId"
    
    private init() {}
    
    @discardableResult
    public func add(key: String, value: String) -> Bool {
        let addQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        ]
        
        let result: Bool = {
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            } else if status == errSecDuplicateItem {
                return update(key: key, value: value)
            }
            
            debugPrint("addItem Error : \(key))")
            return false
        }()
        
        return result
    }
    
    @discardableResult
    public func load(key: String) -> String? {
        let getQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)
        
        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        
        debugPrint("getItem Error : \(key)")
        return nil
    }
    
    @discardableResult
    public func update(key: String, value: String) -> Bool {
        let prevQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let updateQuery: [CFString: Any] = [
            kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        ]
        
        let result: Bool = {
            let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
            if status == errSecSuccess { return true }
            
            debugPrint("updateItem Error : \(key)")
            return false
        }()
        
        return result
    }
    
    @discardableResult
    public func delete(key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess { return true }
        
        debugPrint("delete Error : \(key)")
        return false
    }
}

