//
//  PopupViewController+Demo.swift
//  DesignSystem
//
//  Created by 박현준 on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

public class PopupViewController: DesignSystemBaseViewController {

    // MARK: - Properties
    public let addCommonBudgetButton: UIButton = {
        let button = UIButton()
        button.setTitle("예산 추가", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCommonBudgetButtonTapped), for: .touchUpInside)
        return button
    }()

    public let addTotalBudgetButton: UIButton = {
        let button = UIButton()
        button.setTitle("공동 예산 추가", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTotalBudgetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public let calendarWarningButton: UIButton = {
        let button = UIButton()
        button.setTitle("여행 날짜 검증", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calendarWarningButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public let expenseDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(expenseDeleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public let expenseSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("환율 변경", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(expenseSettingButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "popup"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - set UI
    public override func setupView() {
        super.setupView()
        [
            addCommonBudgetButton,
            addTotalBudgetButton,
            calendarWarningButton,
            logoutButton,
            expenseDeleteButton,
            expenseSettingButton,
        ].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    @objc
    func addCommonBudgetButtonTapped() {
        let vc = YBPopupTypeViewController(popupType: .addCommonBudget)
        vc.delegate = self
        presentPopup(presentedViewController: vc)
    }
    
    @objc
    func addTotalBudgetButtonTapped() {
        let vc = YBPopupTypeViewController(popupType: .addTotalBudget)
        vc.delegate = self
        presentPopup(presentedViewController: vc)
    }
    
    @objc
    func calendarWarningButtonTapped() {
        let vc = YBPopupTypeViewController(popupType: .calendarWarning)
        vc.delegate = self
        presentPopup(presentedViewController: vc)
    }
    
    @objc
    func logoutButtonTapped() {
        let vc = YBPopupTypeViewController(popupType: .logout)
        vc.delegate = self
        presentPopup(presentedViewController: vc)
    }
    
    @objc
    func expenseDeleteButtonTapped() {
        let vc = YBPopupTypeViewController(popupType: .expenseDelete)
        vc.delegate = self
        presentPopup(presentedViewController: vc)
    }
    
    @objc
    func expenseSettingButtonTapped() {
        let vc = YBPopupTypeViewController(popupType: .expenseSetting)
        vc.delegate = self
        presentPopup(presentedViewController: vc)
    }
}

// MARK: - 여기서 popup action 처리
extension PopupViewController: YBPopupViewControllerDelegate {
    public func cancelButtonTapped() {
        print("취소")
    }
    
    public func actionButtonTapped() {
        print("액션")
    }
}
