//
//  SettingBottomSheetViewController.swift
//  Setting
//
//  Created by 박현준 on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

protocol SettingBottomSheetViewControllerDelegate: AnyObject {
    func modifyTitleButtonTapped()
    func modifyDateButtonTapped()
}

public class SettingBottomSheetViewController: YBBottomSheetViewController {
    
    weak var delegate: SettingBottomSheetViewControllerDelegate?
    
    // MARK: - Properties
    private let settingTitleLabel = YBLabel(text: "편집", font: .title1, textColor: .black)
    private let modifyTitleButton: UIButton = {
        $0.setTitle("제목 수정", for: .normal)
        $0.setTitleColor(YBColor.gray6.color, for: .normal)
        $0.titleLabel?.font = YBFont.body1.font
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(modifyTitleButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
//    private let modifyDateButton: UIButton = {
//        $0.setTitle("날짜 수정", for: .normal)
//        $0.setTitleColor(YBColor.gray6.color, for: .normal)
//        $0.titleLabel?.font = YBFont.body1.font
//        $0.contentHorizontalAlignment = .left
//        $0.addTarget(self, action: #selector(modifyDateButtonTapped), for: .touchUpInside)
//        return $0
//    }(UIButton())
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
    
    override public init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Set UI
    private func setLayouts() {
        containerView.addSubview(settingTitleLabel)
        containerView.addSubview(modifyTitleButton)
//        containerView.addSubview(modifyDateButton)
        
        settingTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        modifyTitleButton.snp.makeConstraints { make in
            make.top.equalTo(settingTitleLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(25)
        }
//        modifyDateButton.snp.makeConstraints { make in
//            make.top.equalTo(modifyTitleButton.snp.bottom).inset(-16)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(25)
//        }
    }
    
    // MARK: - Handler
    @objc private func modifyTitleButtonTapped() {
        delegate?.modifyTitleButtonTapped()
        self.dismiss(animated: true)
    }
    
    @objc private func modifyDateButtonTapped() {
        delegate?.modifyDateButtonTapped()
        self.dismiss(animated: true)
    }
}
