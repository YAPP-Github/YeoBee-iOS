//
//  TotalPriceSubView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

import DesignSystem
import RxGesture

final class TotalPriceSubView: UIView {

    var disposeBag: DisposeBag = DisposeBag()

    // MARK: label

    let titleLabel = YBLabel(font: .body3, textColor: .gray4)
    let priceLabel = YBDecimalLabel(unit: .krw, font: .body3, textColor: .gray6)
    let verticalDivider = YBDivider(.verticalLine, height: 1, color: .gray3)
    let stackView = UIStackView()

    init(isDivider: Bool = false) {
        
        super.init(frame: .zero)
        
        verticalDivider.isHidden = isDivider == false
        stackView.axis = .horizontal
        stackView.spacing = 6

        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(verticalDivider)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(text: String, price: Int) {
        titleLabel.text = text
        priceLabel.setPrice(price)
    }
}
