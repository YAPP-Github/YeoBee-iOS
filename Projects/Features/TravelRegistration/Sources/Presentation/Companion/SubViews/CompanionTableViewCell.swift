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
        if companion.type == FaceImageType.face2.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face2.image
        } else if companion.type == FaceImageType.face3.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face3.image
        } else if companion.type == FaceImageType.face4.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face4.image
        } else if companion.type == FaceImageType.face5.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face5.image
        } else if companion.type == FaceImageType.face6.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face6.image
        } else if companion.type == FaceImageType.face7.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face7.image
        } else if companion.type == FaceImageType.face8.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face8.image
        } else if companion.type == FaceImageType.face9.rawValue {
            profileImageView.image = DesignSystemAsset.Icons.face9.image
        }
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

