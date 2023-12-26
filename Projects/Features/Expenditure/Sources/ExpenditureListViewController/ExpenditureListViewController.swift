//
//  ExpenditureListViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

import DesignSystem
import SnapKit

public final class ExpenditureListViewController: UIViewController, View {

    public var disposeBag: DisposeBag = DisposeBag()

    // MARK: View

    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    let containerStackView = UIStackView()
    let totalPriceView = TotalPriceView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setLayouts()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public func bind(reactor: ExpenditureListReactor) {
        totalPriceView.reactor = reactor.totalPriceReactorFactory
    }

    func setupViews() {
        title = "일본 여행"

        scrollView.showsVerticalScrollIndicator = false

        view.backgroundColor = YBColor.gray2.color
        scrollContentView.backgroundColor = YBColor.white.color
        scrollContentView.layer.cornerRadius = 10

        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
    }

    func setLayouts() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.horizontalEdges.equalToSuperview()
        }

        scrollView.addSubview(scrollContentView)

        scrollContentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }

        scrollContentView.addSubview(containerStackView)

        containerStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }

        containerStackView.addArrangedSubview(totalPriceView)
    }
}
