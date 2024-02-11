//
//  UpdateUserInfoRequest.swift
//  Entity
//
//  Created by 김태형 on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct UpdateUserInfoRequest: Codable {
    public var nickname: String
    public var profileImageUrl: String?
}
