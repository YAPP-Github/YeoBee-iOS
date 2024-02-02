//
//  HomeViewController.swift
//  Home
//
//  Created by 이호영 
//

import UIKit
import DesignSystem
import Entity
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import Coordinator

public enum HomeSection: CaseIterable {
    case header
    case traveling
    case coming
    case passed
}

enum HomeDataItem: Hashable {
    case header
    case traveling(Trip)
    case coming(Trip)
    case passed(Trip)
}

public final class HomeViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor = HomeReactor()
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeDataItem>?
    private var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeDataItem>()
    
    public var coordinator: HomeCoordinator?

    // MARK: - Properties
    lazy var homeCollectionView = HomeCollectionView()
    private let emptyTripView = EmptyTripView()
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YBColor.gray2.color
        addViews()
        setLayout()
        setDataSource()
        setCollectionViewDelegate()
        bind(reactor: reactor)
        reactor.homeTripUseCase()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let coordinator {
            coordinator.navigationController.isNavigationBarHidden = true
        }
    }

    // MARK: - Set UI
    private func addViews() {
        view.addSubview(homeCollectionView)
        view.addSubview(emptyTripView)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        emptyTripView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(200)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeDataItem>(collectionView: homeCollectionView) { (collectionView, indexPath, homeItem) -> UICollectionViewCell? in
            switch homeItem {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionHeaderViewCell.identifier, for: indexPath) as? HomeCollectionHeaderViewCell else { return UICollectionViewCell() }
                cell.delegate = self
                return cell
            case .traveling(let travelingTrip):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(trip: travelingTrip)
                return cell
            case .coming(let comingTrip):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(trip: comingTrip)
                return cell
            case .passed(let passedTrip):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(trip: passedTrip)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = {[weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let self,
                      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as? HomeSectionHeaderView else {
                    return UICollectionReusableView()
                }
                header.delegate = self
                
                if indexPath.section == self.snapshot.indexOfSection(.traveling) {
                    header.sectionTitleLabel.text = TripType.traveling.rawValue
                    if self.reactor.currentState.travelingTrip.count > 1 {
                        header.moreButton.isHidden = false
                    }
                } else if indexPath.section == self.snapshot.indexOfSection(.coming) {
//                     let items = snapshot.itemIdentifiers(inSection: .coming)
//                     [TODO] 다가오는 가장 빠른 여행 출발일 기준 D-day로 설정
                    header.sectionTitleLabel.text = TripType.coming.rawValue
                    if self.reactor.currentState.comingTrip.count > 1 {
                        header.moreButton.isHidden = false
                    }
                } else if indexPath.section == self.snapshot.indexOfSection(.passed) {
                    header.sectionTitleLabel.text = TripType.passed.rawValue
                    if self.reactor.currentState.passedTrip.count > 1 {
                        header.moreButton.isHidden = false
                    }
                }
                
                return header
            } else {
                return nil
            }
        }
        
        homeCollectionView.dataSource = dataSource
    }
    
    func configureSnapshot(travelingData: [Trip], comingData: [Trip], passedData: [Trip]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeDataItem>()
        snapshot.appendSections([.header])
        snapshot.appendItems([.header], toSection: .header)
        
        if let travelingTrip = travelingData.first {
            snapshot.appendSections([.traveling])
            snapshot.appendItems([.traveling(travelingTrip)], toSection: .traveling)
        }
        if let comingTrip = comingData.first {
            snapshot.appendSections([.coming])
            snapshot.appendItems([.coming(comingTrip)], toSection: .coming)
        }
        if let passedTrip = passedData.first {
            snapshot.appendSections([.passed])
            snapshot.appendItems([.passed(passedTrip)], toSection: .passed)
        }
        
        self.snapshot = snapshot
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setCollectionViewDelegate() {
        homeCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width-48, height: 150)
        } else {
            return CGSize(width: UIScreen.main.bounds.width-48, height: 230)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 30)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = snapshot.sectionIdentifiers[indexPath.section]
        
        switch section {
        case .traveling:
            let travelingTrip = snapshot.itemIdentifiers(inSection: .traveling)[indexPath.item]
            self.coordinator?.trip()
            print("Selected traveling Trip: \(travelingTrip) \(indexPath.row)")
        case .coming:
            let comingTrip = snapshot.itemIdentifiers(inSection: .coming)[indexPath.item]
            self.coordinator?.trip()
            print("Selected Coming Trip: \(comingTrip) \(indexPath.row)")
        case .passed:
            let passedTrip = snapshot.itemIdentifiers(inSection: .passed)[indexPath.item]
            self.coordinator?.trip()
            print("Selected Passed Trip: \(passedTrip) \(indexPath.row)")
        case .header:
            break
        }
    }
}

// MARK: - Bind
extension HomeViewController: View {
    public func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindAction(reactor: HomeReactor) {

    }

    func bindState(reactor: HomeReactor) {
        Observable.combineLatest(
            reactor.state.map { $0.travelingTrip },
            reactor.state.map { $0.comingTrip },
            reactor.state.map { $0.passedTrip }
        )
        .do(onNext: { [weak self] traveling, coming, passed in
            self?.emptyTripView.isHidden = (!traveling.isEmpty || !coming.isEmpty || !passed.isEmpty)
        })
        .observe(on: MainScheduler.instance)
        .bind { [weak self] travelingTrip, comingTrip, passedTrip in
            self?.configureSnapshot(
                travelingData: travelingTrip,
                comingData: comingTrip,
                passedData: passedTrip
            )
        }.disposed(by: disposeBag)
    }
}

// MARK: - 프로필 & 여행 등록하기
extension HomeViewController: HomeCollectionHeaderViewCellDelegate {
    func profileButtonTapped() {
        print("프로필로 이동")
    }
    
    func addTripViewTapped() {
        coordinator?.travelRegisteration()
    }
}

// MARK: - 더보기
extension HomeViewController: HomeSectionHeaderViewDelegate {
    func moreButtonTapped(tripType: String) {
        TripType.allCases.forEach {
            if $0.rawValue == tripType {
                coordinator?.moreTrip(tripType: $0)
            }
        }
    }
}

