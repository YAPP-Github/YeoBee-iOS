//
//  TripDateValidationResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 특정 기간 다른 여행들과 겹치는지 여부 확인
public struct TripDateValidationResponse: Codable {
    var overlap: Bool
}
