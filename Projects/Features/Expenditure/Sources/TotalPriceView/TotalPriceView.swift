//
//  TotalPriceViewViewController.swift
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

final class TotalPriceView: UIView, View {

    var disposeBag: DisposeBag = DisposeBag()

    // MARK: label

    let titleLabel = YBLabel(font: .body3, textColor: .gray6)
    let priceLabel = YBLabel(font: .header1, textColor: .gray6)
    let divider = YBDivider(height: 1, color: .gray3)
    let stackView = UIStackView()
    let totalExpandPriceSubView = TotalPriceSubView()
    let totalBudgetPriceSubView = TotalPriceSubView(isDivider: true)
    let secondDivider = YBDivider(height: 1, color: .gray3)

    init() {
        super.init(frame: .zero)

        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(divider)
        addSubview(stackView)
        addSubview(secondDivider)

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }

        stackView.axis = .horizontal
        stackView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(totalBudgetPriceSubView)
        stackView.addArrangedSubview(totalExpandPriceSubView)
        
        secondDivider.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: TotalPriceReactor) {
        let hasBudget: Bool = reactor.currentState.totalBudget > 0

        if hasBudget {
            setTitleLabel(
                text: "예산 잔액",
                price: reactor.currentState.remainBudget
            )
            totalExpandPriceSubView.setData(
                text: "총쓴돈",
                price: reactor.currentState.totalExpandPrice
            )
            totalBudgetPriceSubView.setData(
                text: "총예산",
                price: reactor.currentState.totalBudget
            )
        } else {
            setTitleLabel(
                text: "총 쓴돈",
                price: reactor.currentState.totalExpandPrice
            )
            stackView.isHidden = true
        }
    }
}

// MARK: titleLabel

extension TotalPriceView {
    func setTitleLabel(text: String, price: Int) {
        titleLabel.text = text
        priceLabel.text = "\(price)원"
    }
}
