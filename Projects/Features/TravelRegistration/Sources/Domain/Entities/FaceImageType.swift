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
    case face0 = "Image0"
    case face1 = "Image1"
    case face2 = "Image2"
    case face3 = "Image3"
    case face4 = "Image4"
    case face5 = "Image5"
    case face6 = "Image6"
    case face7 = "Image7"
    case face8 = "Image8"
    case face9 = "Image9"
    
    public func iconImage() -> UIImage {
        switch self {
        case .face0:
            return DesignSystemAsset.Icons.face0.image
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
