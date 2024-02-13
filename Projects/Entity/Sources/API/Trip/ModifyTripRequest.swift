//
//  ModifyTripRequest.swift
//  Entity
//
//  Created by 박현준 on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 여행 수정
public struct ModifyTripRequest: Encodable {
    public var title: String
    public var startDate: String
    public var endDate: String
    public var tripUserList: [ModifyTripUserItemRequest]
    
    public init(
        title: String,
        startDate: String,
        endDate: String,
        modifyTripUserList: [ModifyTripUserItemRequest]
    ) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.tripUserList = modifyTripUserList
    }
}

public struct ModifyTripUserItemRequest: Encodable {
    public var id: Int
    public var name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
