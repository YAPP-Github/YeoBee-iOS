//
//  FetchUserResponse.swift
//  Entity
//
//  Created by 태태's MacBook on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

struct FetchUserResponse: Codable{
    var nickname: String
    var profileImage: String
    var loginProvider: LoginType
}
