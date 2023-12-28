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

public final class ExpenditureListViewController: UIViewController, View, UICollectionViewDelegate {

    public var disposeBag: DisposeBag = DisposeBag()

    // MARK: View

    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let containerStackView = UIStackView()
    private let totalPriceView = TotalPriceView()
    private let tripDateCollectionView = TripDateCollectionView()

    // MARK: DataSources

    private let tripDateDataSource: TripDateDataSource

    public init() {
        tripDateDataSource = TripDateDataSource(
            collectionView: tripDateCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TripDateCell.reuseIdentifier,
                for: indexPath
            ) as? TripDateCell
            cell?.setupCell("금", "11")
            return cell
        })
        super.init(nibName: nil, bundle: nil)
    }

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

        reactor.state.map { $0.snapshot }
            .subscribe(onNext: { [weak self] snapshot in
                print(snapshot)
                self?.tripDateDataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)

        totalPriceView.rx.tappedTotalExpandView
            .subscribe(onNext: { _ in
                print("tappedTotalExpandView")
            })
            .disposed(by: disposeBag)

        totalPriceView.rx.tappedBudgetPriceView
            .subscribe(onNext: { _ in
                print("tappedBudgetPriceView")
            })
            .disposed(by: disposeBag)
    }

    func setupViews() {
        title = "일본 여행"

        scrollView.showsVerticalScrollIndicator = false

        view.backgroundColor = YBColor.gray2.color
        scrollContentView.backgroundColor = YBColor.white.color
        scrollContentView.layer.cornerRadius = 10

        containerStackView.axis = .vertical
        containerStackView.alignment = .fill

        tripDateCollectionView.rx.setDelegate(self)
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
