//
//  Companion.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/10/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

public struct Companion: Hashable {
    public var uuid = UUID()
    public var name: String
    public var type: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public init(uuid: UUID = UUID(), name: String, type: String) {
        self.uuid = uuid
        self.name = name
        self.type = type
    }
}
