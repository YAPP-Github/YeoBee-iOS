//
//  AddCompanionView.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

final class AddCompanionView: UIView {
    private let addCompanionLabel = YBLabel(text: "동행을 추가해주세요.", font: .header2, textColor: .black)
    
    let addCompanionButton = YBPaddingButton(text: "+  추가", isGradient: true, padding: .small)
    
    private let myProfileImageView: UIImageView = {
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let myProfileNameLabel = YBLabel(font: .body1, textColor: .black)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            addCompanionLabel,
            addCompanionButton,
            myProfileImageView,
            myProfileNameLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        addCompanionButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        addCompanionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(addCompanionButton.snp.centerY)
        }
        myProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(addCompanionLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.size.equalTo(44)
        }
        myProfileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(myProfileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(myProfileImageView.snp.centerY)
        }
    }
    
    func configure() {
        myProfileImageView.backgroundColor = .systemPink
        myProfileNameLabel.text = "여비"
    }
}
