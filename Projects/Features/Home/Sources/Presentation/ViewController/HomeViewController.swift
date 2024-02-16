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
    case header(FetchUserResponse)
    case traveling(TripItem)
    case coming(TripItem)
    case passed(TripItem)
}

public final class HomeViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor = HomeReactor()
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeDataItem>?
    private var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeDataItem>()
    public var coordinator: HomeCoordinator?
    private let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd"
        return $0
    }(DateFormatter())

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
        dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeDataItem>(collectionView: homeCollectionView) 
        { (collectionView, indexPath, homeItem) -> UICollectionViewCell? in
            switch homeItem {
            case .header(let fetchUserResponse):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionHeaderViewCell.identifier,
                    for: indexPath
                ) as? HomeCollectionHeaderViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(fetchUserResponse: fetchUserResponse)
                cell.delegate = self
                return cell
            case .traveling(let travelingTrip):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.identifier, 
                    for: indexPath
                ) as? HomeCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(tripItem: travelingTrip)
                return cell
            case .coming(let comingTrip):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.identifier,
                    for: indexPath
                ) as? HomeCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(tripItem: comingTrip)
                return cell
            case .passed(let passedTrip):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.identifier,
                    for: indexPath
                ) as? HomeCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(tripItem: passedTrip)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath
        ) -> UICollectionReusableView? in
            
            if kind == UICollectionView.elementKindSectionHeader {
                guard let self,
                      let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: HomeSectionHeaderView.identifier,
                        for: indexPath
                      ) as? HomeSectionHeaderView else {
                    return UICollectionReusableView()
                }
                header.delegate = self
                
                if indexPath.section == self.snapshot.indexOfSection(.traveling) {
                    header.sectionTitleLabel.text = TripType.traveling.rawValue
                    if self.reactor.currentState.travelingTrip.count > 1 {
                        header.moreButton.isHidden = false
                    }
                } else if indexPath.section == self.snapshot.indexOfSection(.coming) {
                    let items = snapshot.itemIdentifiers(inSection: .coming)
                    if let item = items.first {
                        switch item {
                        case .header, .traveling, .passed:
                            break
                        case .coming(let tripItem):
                            // 현재 날짜와 startDate 차이 계산
                            if let startDate = dateFormatter.date(from: tripItem.startDate) {
                                if let daysDiff = Calendar.current.dateComponents([.day], from: Date(), to: startDate).day {
                                    header.sectionTitleLabel.text = "\(TripType.coming.rawValue), D-\(daysDiff)"
                                    if self.reactor.currentState.comingTrip.count > 1 {
                                        header.moreButton.isHidden = false
                                    }
                                }
                            }
                        }
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
    
    func configureSnapshot(userInfo: FetchUserResponse, travelingData: [TripItem], comingData: [TripItem], passedData: [TripItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeDataItem>()
        
        snapshot.appendSections([.header])
        snapshot.appendItems([.header(userInfo)], toSection: .header)
        
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
        coordinator?.delegate = self
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
            if case let .traveling(tripItem) = snapshot.itemIdentifiers(inSection: .traveling)[indexPath.item] {
                self.coordinator?.trip(tripItem: tripItem)
            }
        case .coming:
            if case let .coming(tripItem) = snapshot.itemIdentifiers(inSection: .coming)[indexPath.item] {
                self.coordinator?.trip(tripItem: tripItem)
            }
        case .passed:
            if case let .passed(tripItem) = snapshot.itemIdentifiers(inSection: .passed)[indexPath.item] {
                self.coordinator?.trip(tripItem: tripItem)
            }
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
            reactor.state.compactMap { $0.userInfo },
            reactor.state.map { $0.travelingTrip },
            reactor.state.map { $0.comingTrip },
            reactor.state.map { $0.passedTrip }
        )
        .do(onNext: { [weak self] userInfo, traveling, coming, passed in
            self?.emptyTripView.isHidden = (!traveling.isEmpty || !coming.isEmpty || !passed.isEmpty)
        })
        .observe(on: MainScheduler.instance)
        .bind { [weak self] userInfo, travelingTrip, comingTrip, passedTrip in
            self?.configureSnapshot(
                userInfo: userInfo,
                travelingData: travelingTrip,
                comingData: comingTrip,
                passedData: passedTrip
            )
        }
        .disposed(by: disposeBag)
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
        TripType.allCases.forEach { tripTypeCase in
            if let coordinator = coordinator,
               let firstCharacter = tripType.first,
               tripTypeCase.rawValue.first == firstCharacter {
                
                let moreTripReactor = MoreTripReactor(tripType: tripTypeCase)
                let moreTripViewController = MoreTripViewController(coordinator: coordinator, reactor: moreTripReactor)
                navigationController?.isNavigationBarHidden = false
                navigationController?.pushViewController(moreTripViewController, animated: true)
            }
        }
    }
}

// MARK: - 여행 등록 완료 후
extension HomeViewController: HomeCoordinatorDelegate {
    public func finishedRegistration() {
        reactor.homeTripUseCase()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let toast = Toast.text(icon: .complete, "새로운 여행이 등록 되었어요!")
            toast.show()
        }
    }
}
