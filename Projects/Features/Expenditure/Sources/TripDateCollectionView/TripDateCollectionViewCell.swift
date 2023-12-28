//
//  TripDateCollectionViewCell.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift
import DesignSystem
import SnapKit

final class TripDateCell: UICollectionViewCell {

    // MARK: Properties

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    private var disposeBag = DisposeBag()

    // MARK: Views

    private let weekLabel = YBLabel(font: .body3, textColor: .gray6)
    private let dayLabel = YBLabel(font: .body1, textColor: .gray6)

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()

        contentView.addSubview(weekLabel)
        contentView.addSubview(dayLabel)

        weekLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(weekLabel.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }

    public func setupCell(_ week: String, _ day: String) {
        weekLabel.text = week
        dayLabel.text = day
    }
}

extension TripDateCell {

}
