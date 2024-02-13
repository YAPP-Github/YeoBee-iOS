//
//  UserState.swift
//  Entity
//
//  Created by 김태형 on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public enum UserState: String, Codable, Equatable {
    case onboardingNeeded = "ONBOARDING_NEEDED"
    case onboardingCompleted = "ONBOARDING_COMPLETE"
}
