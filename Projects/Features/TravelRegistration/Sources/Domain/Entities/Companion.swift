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
    public var imageUrl: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public init(uuid: UUID = UUID(), name: String, imageUrl: String) {
        self.uuid = uuid
        self.name = name
        self.imageUrl = imageUrl
    }
}
