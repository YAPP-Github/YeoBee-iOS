//
//  UserDefaultsRepository.swift
//  Repository
//
//  Created by Hoyoung Lee on 3/24/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Entity
import ComposableArchitecture

public struct UserDefaultsRepository {
    public var valueForKey: (String) -> Any?
    public var setValueForKey: (Any?, String) -> Void
}

extension UserDefaultsRepository {
    public func value<Value: Codable>(forKey key: UserDefaultsKey<Value>) -> Value? {
        guard let data = valueForKey(key.name) else { return nil }
        guard let value = data as? String else {
            return nil
        }
        guard let dataValue = value.data(using: .utf8) else { return nil }
        do {
            return try JSONDecoder().decode(Value.self, from: dataValue)
        } catch {
            return nil
        }
    }

    public func setValue<Value: Codable>(_ value: Value, forKey key: UserDefaultsKey<Value>) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(value)
            setValueForKey(String(data: data, encoding: .utf8), key.name)
            return
        } catch {
            return
        }
    }
}

extension UserDefaultsRepository: TestDependencyKey {
    public static let testValue: Self = unimplemented()
}

extension DependencyValues {
    public var userDefaultsRepository: UserDefaultsRepository {
        get { self[UserDefaultsRepository.self] }
        set { self[UserDefaultsRepository.self] = newValue }
    }
}

enum UserDefaultsError: Error {
    case getFail
}

extension UserDefaultsRepository: DependencyKey {
    public static var liveValue: UserDefaultsRepository {
        let userDefaults = UserDefaults()
        return Self(
            valueForKey: { key in
                let data = userDefaults.value(forKey: key)
                return data
            },
            setValueForKey: { value, key in
                userDefaults.set(value, forKey: key)
            }
        )
    }
}

public protocol UserDefaultsKeyType {}

public struct UserDefaultsKey<Value: UserDefaultsKeyType> {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

extension TripItem?: UserDefaultsKeyType {}

extension [Int: Currency]: UserDefaultsKeyType {}

public protocol UserDefaultsData: Codable {}

extension UserDefaultsKey where Value == TripItem? {
    public static let lastShowingTrip: UserDefaultsKey<Value> = .init(
        name: "lastShowingTrip"
    )
}

extension UserDefaultsKey where Value == [Int: Currency] {
    public static let selectedCurrency: UserDefaultsKey<Value> = .init(
        name: "selectedCurrency"
    )
}

