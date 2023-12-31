//
//  HomeViewController.swift
//  Home
//
//  Created by 이호영 
//

import UIKit
import DesignSystem
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

enum HomeSection: CaseIterable {
    case header
    case coming
    case passed
}

enum HomeDataItem: Hashable {
    case header
    case coming(Trip)
    case passed(Trip)
}

public class HomeViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor = HomeReactor()
    
    // MARK: - Properties
    lazy var homeCollectionView = HomeCollectionView()
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YBColor.gray2.color
        addViews()
        setLayout()
        setDataSource()
        setCollectionViewDelegate()
        setNavBar()
        bind(reactor: reactor)
        // 초기 더미 데이터
        reactor.configureSnapshot(comingData: TripDummy.coming.getTrips(), passedData: TripDummy.passed.getTrips())
    }

    // MARK: - Set UI
    private func addViews() {
        view.addSubview(homeCollectionView)
    }
    
    private func setLayout() {
        homeCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setDataSource() {
        reactor.dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeDataItem>(collectionView: homeCollectionView) { (collectionView, indexPath, homeItem) -> UICollectionViewCell? in
            switch homeItem {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionHeaderViewCell.identifier, for: indexPath) as? HomeCollectionHeaderViewCell else { return UICollectionViewCell() }
                cell.delegate = self
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

        reactor.dataSource.supplementaryViewProvider = {[weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as? HomeSectionHeaderView else {
                    return UICollectionReusableView()
                }
                
                if let snapshot = self?.reactor.snapshot {
                    if indexPath.section == snapshot.indexOfSection(.coming) {
//                        let items = snapshot.itemIdentifiers(inSection: .coming)
                        // [TODO] 다가오는 가장 빠른 여행 출발일 기준 D-day로 설정
                        header.sectionTitleLabel.text = "다가오는 여행"
                    } else if indexPath.section == snapshot.indexOfSection(.passed) {
                        let items = snapshot.itemIdentifiers(inSection: .passed)
                        header.sectionTitleLabel.text = "지난 여행 (\(items.count))"
                    }
                }
                
                return header
            } else {
                return nil
            }
        }
        
        homeCollectionView.dataSource = reactor.dataSource
    }
    
    private func setCollectionViewDelegate() {
        homeCollectionView.delegate = self
    }
    
    private func setNavBar() {
        navigationController?.isNavigationBarHidden = true
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
        let section = reactor.snapshot.sectionIdentifiers[indexPath.section]
        
        switch section {
        case .coming:
            let comingTrip = reactor.snapshot.itemIdentifiers(inSection: .coming)[indexPath.item]
            print("Selected Coming Trip: \(comingTrip) \(indexPath.row)")
        case .passed:
            let passedTrip = reactor.snapshot.itemIdentifiers(inSection: .passed)[indexPath.item]
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

    }
}

// MARK: - 프로필 & 여행 등록하기
extension HomeViewController: HomeCollectionHeaderViewCellDelegate {
    func profileButtonTapped() {
        print("프로필로 이동")
    }
    
    func addTripViewTapped() {
        print("여행 등록하기로 이동")
    }
}
