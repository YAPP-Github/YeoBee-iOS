//
//  YBPopupType.swift
//  DesignSystem
//
//  Created by Hoyoung Lee on 2/9/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

enum YBPopupType {
    case addCommonBudget
    case addIndividualBudget
    case logout
    case expenseDelete
    case tripDelete
    case expenseSetting
}

extension YBPopupType {
    var image: UIImage? {
        switch self {
        case .addCommonBudget: DesignSystemAsset.Icons.accountBook.image
        case .addIndividualBudget: DesignSystemAsset.Icons.accountBook.image
        case .logout: DesignSystemAsset.Icons.accountBook.image
        case .expenseDelete: DesignSystemAsset.Icons.accountBook.image
        case .tripDelete: DesignSystemAsset.Icons.accountBook.image
        case .expenseSetting: nil
        }
    }

    var title: String {
        switch self {
        case .addCommonBudget: return "예산을 추가해보세요!"
        case .addIndividualBudget: return "공동경비를 추가해보세요!"
        case .logout: return "정말 로그아웃 하시겠어요?"
        case .expenseDelete: return "정말 삭제 하시겠어요?"
        case .tripDelete: return "정말 여행을 삭제하시겠어요?"
        case .expenseSetting: return "환율을 변경하면 이전 항목까지 전부 변경된 값으로 저장돼요."
        }
    }

    var subTitle: String {
        switch self {
        case .addCommonBudget: return "예산은 언제든 다시 추가하실 수 있어요."
        case .addIndividualBudget: return "공동경비는 언제든 다시 추가하실 수 있어요."
        case .logout: return "로그아웃 시 서비스 이용이 불가해요."
        case .expenseDelete: return "삭제한 후에는 복구가 불가해요."
        case .tripDelete: return "삭제한 후에는 복구가 불가해요."
        case .expenseSetting: return "계속해서 변경하시겠어요?"
        }
    }
}
