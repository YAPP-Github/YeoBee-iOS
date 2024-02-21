//
//  Calculations.swift
//  Entity
//
//  Created by Hoyoung Lee on 2/21/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct Calculations: Codable, Hashable {
    public var calculationList: [Calculation]
}

public struct Calculation: Codable, Hashable {
    public var sender: CalculationUser
    public var receiver: CalculationUser
    public var koreanAmount: Int
}

public struct CalculationUser: Codable, Hashable {
    public var userId: Int?
    public var name: String
    public var profileImageURL: String?
}
