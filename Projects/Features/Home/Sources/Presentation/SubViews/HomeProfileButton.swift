//
//  HomeProfileButton.swift
//  Home
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

final class HomeProfileButton: UIButton {
    
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
        $0.numberOfLines = 1
        $0.textColor = YBColor.black.color
        return $0
    }(UILabel())
    
    private let chevronImageView: UIImageView = {
        $0.image = DesignSystemAsset.Icons.rightChevron.image
        return $0
    }(UIImageView())
    
    let profileStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fill
        $0.alignment = .center
        return $0
    }(UIStackView())
    
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
        addSubview(profileStackView)
        
        [
            profileImageView,
            profileNameLabel,
            chevronImageView
        ].forEach {
            profileStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayouts() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        profileStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
