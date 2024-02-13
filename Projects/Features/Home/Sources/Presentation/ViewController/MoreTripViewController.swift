//
//  MoreTripViewController.swift
//  Home
//
//  Created by 박현준 on 1/30/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import Coordinator

enum MoreTripSection: CaseIterable {
    case main
}

enum MoreTripDataItem: Hashable {
    case main(TripItem)
}

public final class MoreTripViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: MoreTripReactor
    private var dataSource: UICollectionViewDiffableDataSource<MoreTripSection, MoreTripDataItem>?
    let coordinator: HomeCoordinator
    
    // MARK: - Properties
    lazy var moreTripCollectionView = HomeCollectionView()
    
    // MARK: - Life Cycles
    init(coordinator: HomeCoordinator, reactor: MoreTripReactor) {
        self.coordinator = coordinator
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YBColor.gray2.color
        configureBar()
        addViews()
        setLayout()
        setDataSource()
        setCollectionViewDelegate()
        bind(reactor: reactor)
        reactor.moreTripUseCase()
    }
    
    // MARK: - Set UI
    private func addViews() {
        view.addSubview(moreTripCollectionView)
    }
    
    private func setLayout() {
        moreTripCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MoreTripSection, MoreTripDataItem>(collectionView: moreTripCollectionView) { (collectionView, indexPath, moreTripItem) -> UICollectionViewCell? in
            switch moreTripItem {
            case .main(let tripItem):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(tripItem: tripItem)
                return cell
            }
        }
        
        moreTripCollectionView.dataSource = dataSource
    }
    
    func configureSnapshot(tripItems: [TripItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<MoreTripSection, MoreTripDataItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tripItems.map { .main($0) }, toSection: .main)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setCollectionViewDelegate() {
        moreTripCollectionView.delegate = self
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationBar.barTintColor = YBColor.gray2.color
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("deinit MoreTripViewController")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoreTripViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-48, height: 230)
    }
}

// MARK: - UICollectionViewDelegate
extension MoreTripViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tripItem = reactor.currentState.trips[indexPath.row]
        coordinator.trip(tripItem: tripItem)
    }
}

// MARK: - Bind
extension MoreTripViewController: View {
    public func bind(reactor: MoreTripReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindAction(reactor: MoreTripReactor) {
        
    }
    
    func bindState(reactor: MoreTripReactor) {
        reactor.state
            .map { $0.tripType }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] tripType in
                switch tripType {
                case .traveling:
                    self?.title = "여행 중"
                case .coming:
                    self?.title = "다가오는 여행"
                case .passed:
                    self?.title = "지난 여행"
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.trips }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] tripItems in
                self?.configureSnapshot(tripItems: tripItems)
            }
            .disposed(by: disposeBag)
    }
}
