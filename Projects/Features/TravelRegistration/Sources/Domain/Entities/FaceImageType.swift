//
//  FaceImageType.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/26/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import YBNetwork

public enum FaceImageType: CaseIterable {
    case face0
    case face1
    case face2
    case face3
    case face4
    case face5
    case face6
    case face7
    case face8
    case face9
    
    public var imageURL: String {
        switch self {
        case .face0:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile0.svg"
        case .face1:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile1.svg"
        case .face2:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile2.svg"
        case .face3:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile3.svg"
        case .face4:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile4.svg"
        case .face5:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile5.svg"
        case .face6:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile6.svg"
        case .face7:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile7.svg"
        case .face8:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile8.svg"
        case .face9:
            return "\(YeoBeeAPI.shared.baseURL ?? "")/static/user/profile/profile9.svg"
        }
    }
    
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
