//
//  SettingCompanionCell.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import TravelRegistration

class SettingCompanionCell: UITableViewCell {
    static let identifier = "SettingCompanionCell"
    
    var companion: Companion? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let profileNameLabel = YBLabel(font: .body1, textColor: .black)
    private let editButton = YBIconButton(image: DesignSystemAsset.Icons.editButton.image)
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        addViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileImageView.image = nil
        profileNameLabel.text = ""
    }
    
    // MARK: - Set UI
    private func setView() {
        selectionStyle = .none
    }
    
    private func addViews() {
        [
            profileImageView,
            profileNameLabel,
            editButton
        ].forEach {
            contentView.addSubview($0)
        }
    }
    private func setLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        profileNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).inset(-12)
        }
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(42)
        }
    }
    
    func configure() {
        guard let companion else { return }
        profileNameLabel.text = companion.name
        profileImageView.image = FaceImageType(rawValue: companion.type)?.iconImage()
    }
}
