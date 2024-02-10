//
//  API.swift
//  YBNetwork
//
//  Created by 김태형 on 2/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

class YeoBeeAPI {
    static let shared = YeoBeeAPI()
    public init() {}
    
    public let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
}