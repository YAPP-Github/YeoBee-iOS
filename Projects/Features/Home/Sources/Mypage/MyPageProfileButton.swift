//
//  MyPageProfileButton.swift
//  MyPage
//
//  Created by 김태형 on 2/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

final class MyPageProfileButton: UIButton {
    var nickname: String {
        didSet {
            profileNameLabel.text = nickname
        }
    }
    private let profileNameLabel = YBLabel(text: "", font: .header2, textColor: .black)
    private let chevronImageView = UIImageView(image: DesignSystemAsset.Icons.next.image)
    var onTap: (() -> Void)?
    
    // MARK: - Init
    init(frame: CGRect, nickname: String) {
        self.nickname = nickname
        super.init(frame: frame)
        addViews()
        setLayouts()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // MARK: - Set UI
    private func addViews() {
        addSubview(profileNameLabel)
        addSubview(chevronImageView)
    }
    
    private func setLayouts() {
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        chevronImageView.snp.makeConstraints { make in
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(profileNameLabel.snp.centerY)
        }
    }
    
    @objc private func buttonTapped() {
        onTap?()
    }
}
