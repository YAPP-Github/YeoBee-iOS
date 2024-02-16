//
//  PaymentMethod.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 결제 방식을 위한 Enum
public enum PaymentMethod: String, Codable {
    case cash = "현금만"
    case card = "카드만"
}

public extension PaymentMethod {
    var apiText: String {
        switch self {
        case .cash: "CASH"
        case .card: "CARD"
        }
    }

}
