//
//  YBPopupViewController.swift
//  DesignSystem
//
//  Created by Hoyoung Lee on 2/9/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class YBPopupViewController: UIViewController {

    // MARK: - Properties
    public let popupType: YBPopupType
    fileprivate let sheetContentView = UIView()
    public let containerView = UIView()

    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setContraints()
    }

    public init(popupType: YBPopupType) {
        self.popupType = popupType
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    public func setContraints() {
        view.addSubview(sheetContentView)
        sheetContentView.addSubview(containerView)
        
        switch popupType {
        case .addCommonBudget, .addTotalBudget, .calendarWarning, .logout, .expenseDelete, .tripDelete:
            sheetContentView.snp.makeConstraints { make in
                make.height.equalTo(291)
                make.leading.trailing.equalToSuperview().inset(24)
                make.center.equalToSuperview()
            }
        case .currencySetting:
            sheetContentView.snp.makeConstraints { make in
                make.height.equalTo(236)
                make.leading.trailing.equalToSuperview().inset(24)
                make.center.equalToSuperview()
            }
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func setViews() {
        view.backgroundColor = .clear
        sheetContentView.backgroundColor = .white
        sheetContentView.layer.cornerRadius = 20
        sheetContentView.clipsToBounds = true
    }
}
