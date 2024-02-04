//
//  EmptyTripView.swift
//  DesignSystem
//
//  Created by 박현준 on 1/31/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import SnapKit

public final class EmptyTripView: UIView {
    
    private let emptyImageView: UIImageView = {
        $0.image = DesignSystemAsset.Icons.emptyTrip.image
        return $0
    }(UIImageView())
    
    private let titleLabel = YBLabel(text: "등록된 여행이 없어요", font: .header2, textColor: .black)
    private let subtitleLabel = YBLabel(text: "여행을 등록해보세요!", font: .body3, textColor: .gray5)
    
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
            emptyImageView,
            titleLabel,
            subtitleLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        emptyImageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).inset(-30)
            make.centerX.equalToSuperview()
            make.height.equalTo(128)
            make.width.equalTo(149)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-5)
            make.centerX.equalToSuperview()
        }
    }
}
