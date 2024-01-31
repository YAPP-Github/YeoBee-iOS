//
//  YBEmptyView.swift
//  DesignSystem
//
//  Created by 박현준 on 1/31/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import SnapKit

public final class YBEmptyView: UIView {
    
    private let emptyImageView: UIImageView = {
        $0.image = DesignSystemAsset.Icons.emptyImage.image
        return $0
    }(UIImageView())
    
    private let titleLabel = YBLabel(font: .title1, textColor: .gray5)
    
    // MARK: - Init
    public init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
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
            emptyImageView,
            titleLabel,
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        emptyImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(84)
            make.width.equalTo(93)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).inset(-30)
            make.centerX.equalToSuperview()
        }
    }
}
