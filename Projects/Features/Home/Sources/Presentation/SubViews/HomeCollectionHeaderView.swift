//
//  HomeCollectionHeaderView.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

class HomeCollectionHeaderView: UICollectionReusableView {
    static let identifier = "HomeCollectionHeaderView"
    
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        $0.image = UIImage(systemName: "circle")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 30 / 2
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let profileNameLabel: UILabel = {
        $0.text = "양송이"
        $0.font = YBFont.body2.font
        $0.textColor = .black
        return $0
    }(UILabel())
    
    let chevronButton: UIButton = {
        $0.setImage(UIImage(systemName: "chevron.right")?
            .withTintColor(YBColor.gray4.color, renderingMode: .alwaysOriginal) , for: .normal)
        return $0
    }(UIButton())
    
    let addTripView = HomeAddTripView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addViews()
        setLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // MARK: - Set UI
    private func setView() {
        backgroundColor = .clear
    }
    
    private func addViews() {
        [
            profileImageView,
            profileNameLabel,
            chevronButton,
            addTripView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.top.equalToSuperview().inset(20)
        }
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).inset(-10)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        chevronButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalTo(profileNameLabel.snp.trailing).inset(-10)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        addTripView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(95)
        }
    }
    
}
