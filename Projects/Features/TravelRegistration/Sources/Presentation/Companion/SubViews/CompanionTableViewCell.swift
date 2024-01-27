//
//  CompanionTableViewCell.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/9/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift
import RxCocoa

protocol CompanionTableViewCellDelegate: AnyObject {
    func changeCompanionName(companion: Companion)
    func deleteCompanion(companion: Companion)
}

class CompanionTableViewCell: UITableViewCell {
    static let identifier = "CompanionTableViewCell"
    weak var delegate: CompanionTableViewCellDelegate?
    var disposeBag = DisposeBag()
    
    var companion: Companion? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let profileNameLabel = YBLabel(font: .body1, textColor: .black)
    let editButton = YBIconButton(image: DesignSystemAsset.Icons.editButton.image)
    let deleteButton = YBIconButton(image: DesignSystemAsset.Icons.deleteButton.image)
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        addViews()
        setLayout()
        bind()
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
        backgroundColor = .white
    }
    
    private func addViews() {
        [
            profileImageView,
            profileNameLabel,
            editButton,
            deleteButton
        ].forEach {
            contentView.addSubview($0)
        }
    }
    private func setLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(44)
        }
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(42)
        }
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(deleteButton.snp.leading).inset(-10)
            make.size.equalTo(deleteButton.snp.size)
        }
    }
    
    func configure() {
        guard let companion = companion else { return }
        
        profileNameLabel.text = companion.name
        profileImageView.image = FaceImageType(rawValue: companion.type)?.iconImage()
    }
    
    private func bind() {
        editButton.rx.tap
            .bind { [weak self] _ in
                if let companion = self?.companion {
                    self?.delegate?.changeCompanionName(companion: companion)
                }
            }.disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind { [weak self] _ in
                if let companion = self?.companion {
                    self?.delegate?.deleteCompanion(companion: companion)
                }
            }.disposed(by: disposeBag)
    }
}

