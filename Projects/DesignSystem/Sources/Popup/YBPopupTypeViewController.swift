//
//  YBPopupTypeViewController.swift
//  DesignSystem
//
//  Created by 박현준 on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import SnapKit

public protocol YBPopupViewControllerDelegate: AnyObject {
    func cancelButtonTapped()
    func actionButtonTapped()
}

final public class YBPopupTypeViewController: YBPopupViewController {
    
    public weak var delegate: YBPopupViewControllerDelegate?
    
    // MARK: - Properties
    private let popupIconImageView = UIImageView()
    private let titleMessageLabel = YBLabel(font: .header2, textColor: .black, textAlignment: .center)
    private let subtitleMessageLabel = YBLabel(font: .body3, textColor: .gray5, textAlignment: .center)
    private var cancelButton = YBTextButton(text: "", appearance: .defaultDisable, size: .medium)
    private var actionButton = YBTextButton(text: "", appearance: .default, size: .medium)
    private let buttonStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 13
        return $0
    }(UIStackView())
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setLayouts()
        handleTarget()
    }
    
    override public init(popupType: YBPopupType) {
        super.init(popupType: popupType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Set UI
    private func setView() {
        switch popupType {
        case .addCommonBudget, .addTotalBudget:
            cancelButton.setTitle("안 할래요", for: .normal)
            actionButton.setTitle("추가할래요", for: .normal)
        case .calendarWarning:
            cancelButton.setTitle("취소하기", for: .normal)
            actionButton.setTitle("등록하기", for: .normal)
        case .logout:
            cancelButton.setTitle("취소하기", for: .normal)
            actionButton.setTitle("로그아웃", for: .normal)
        case .expenseDelete:
            cancelButton.setTitle("취소하기", for: .normal)
            actionButton.setTitle("삭제하기", for: .normal)
        case .tripDelete:
            cancelButton.setTitle("취소하기", for: .normal)
            actionButton.setTitle("삭제하기", for: .normal)
        case .currencySetting:
            cancelButton.setTitle("취소하기", for: .normal)
            actionButton.setTitle("변경하기", for: .normal)
            titleMessageLabel.numberOfLines = 2
        }
        
        let attributedString = NSMutableAttributedString(string: popupType.title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        titleMessageLabel.attributedText = attributedString
        
        popupIconImageView.image = popupType.image
        subtitleMessageLabel.text = popupType.subTitle
    }
    
    private func setLayouts() {
        containerView.addSubview(titleMessageLabel)
        containerView.addSubview(subtitleMessageLabel)
        containerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(actionButton)
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(30)
        }
        subtitleMessageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackView.snp.top).inset(-30)
            make.centerX.equalToSuperview()
        }
        titleMessageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(subtitleMessageLabel.snp.top).inset(-7)
            make.centerX.equalToSuperview()
        }
        
        switch popupType {
        case .addCommonBudget, .addTotalBudget:
            containerView.addSubview(popupIconImageView)
            
            popupIconImageView.snp.makeConstraints { make in
                make.bottom.equalTo(titleMessageLabel.snp.top).inset(-30)
                make.centerX.equalToSuperview()
                make.width.equalTo(47)
                make.height.equalTo(65)
            }
        case .calendarWarning:
            containerView.addSubview(popupIconImageView)
            
            popupIconImageView.snp.makeConstraints { make in
                make.bottom.equalTo(titleMessageLabel.snp.top).inset(-30)
                make.centerX.equalToSuperview()
                make.size.equalTo(65)
            }
        case .logout, .expenseDelete, .tripDelete:
            containerView.addSubview(popupIconImageView)
            
            popupIconImageView.snp.makeConstraints { make in
                make.bottom.equalTo(titleMessageLabel.snp.top).inset(-30)
                make.centerX.equalToSuperview()
                make.width.equalTo(49)
                make.height.equalTo(56)
            }
        case .currencySetting:
            break
        }
    }
    
    private func handleTarget() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Handler
    @objc private func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true)
    }
    
    @objc private func actionButtonTapped() {
        delegate?.actionButtonTapped()
        self.dismiss(animated: true)
    }
}
