//
//  SettingCompanionCell.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import YBNetwork
import Entity
import TravelRegistration
import Kingfisher

protocol SettingCompanionCellDelegate: AnyObject {
    func editButtonTapped(companion: TripUserItem)
}

class SettingCompanionCell: UITableViewCell {
    static let identifier = "SettingCompanionCell"
    weak var delegate: SettingCompanionCellDelegate?
    
    var companion: TripUserItem? {
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
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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
        
        if let profileImageUrl = URL(string: companion.profileImageUrl ?? "") {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: profileImageUrl)
        } else {
            profileImageView.image = DesignSystemAsset.Icons.face0.image
        }
        
        // 자신의 ID와 companion의 ID와 같은 경우 (동행자 자신인 경우)
        if let userId = companion.userId {
            if String(userId) == KeychainManager.shared.load(key: KeychainManager.userId) {
                self.editButton.isHidden = true
            }
        }
    }
    
    @objc func editButtonTapped() {
        guard let companion else { return }
        delegate?.editButtonTapped(companion: companion)
    }
}
