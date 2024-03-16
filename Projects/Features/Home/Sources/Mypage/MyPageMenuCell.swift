//
//  MyPageMenuCell.swift
//  MyPage
//
//  Created by 김태형 on 2/18/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem

class MyPageMenuCell: UITableViewCell {
    let reuseableIdentifier = "MyPageMenuCell"
    let titleLabel = YBLabel(font: .body1)
    let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.Icons.next.image
        return imageView
    }()
    let versionLabel = YBLabel(text: "", font: .body1, textColor: .gray5)
  
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseableIdentifier)
        setupViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
      if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "v\(appVersion)"
        }
        versionLabel.isHidden = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(nextImageView)
        contentView.addSubview(versionLabel)
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        nextImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(4)
            make.height.equalTo(8)
            make.centerY.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
}
