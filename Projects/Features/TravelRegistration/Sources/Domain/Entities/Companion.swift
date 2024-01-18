//
//  Companion.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/10/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

public struct Companion: Hashable {
    var uuid = UUID()
    var name: String
    var image: UIImage
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
