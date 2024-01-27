//
//  FaceImageType.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/26/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem

public enum FaceImageType: String, CaseIterable {
    case face1 = "face1"
    case face2 = "face2"
    case face3 = "face3"
    case face4 = "face4"
    case face5 = "face5"
    case face6 = "face6"
    case face7 = "face7"
    case face8 = "face8"
    case face9 = "face9"
    
    public func iconImage() -> UIImage {
        switch self {
        case .face1:
            return DesignSystemAsset.Icons.face1.image
        case .face2:
            return DesignSystemAsset.Icons.face2.image
        case .face3:
            return DesignSystemAsset.Icons.face3.image
        case .face4:
            return DesignSystemAsset.Icons.face4.image
        case .face5:
            return DesignSystemAsset.Icons.face5.image
        case .face6:
            return DesignSystemAsset.Icons.face6.image
        case .face7:
            return DesignSystemAsset.Icons.face7.image
        case .face8:
            return DesignSystemAsset.Icons.face8.image
        case .face9:
            return DesignSystemAsset.Icons.face9.image
        }
    }
}
