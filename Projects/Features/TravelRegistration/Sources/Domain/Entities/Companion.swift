//
//  Companion.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/10/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct Companion: Hashable {
    var name: String
    var imageURL: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
