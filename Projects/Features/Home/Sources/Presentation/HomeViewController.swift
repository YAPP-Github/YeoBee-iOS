//
//  HomeViewController.swift
//  Home
//
//  Created by 이호영 
//

import UIKit
import DesignSystem
import ReactorKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

enum HomeSection: CaseIterable {
    case header
    case coming
    case passed
}

enum HomeDataItem: Hashable {
    case header
    case coming([Trip])
    case passed([Trip])
}

public class HomeViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    let reactor = HomeReactor()
    // MARK: - Properties
    lazy var homeCollectionView: UICollectionView = {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.delegate = self
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewFlowLayout()))
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YBColor.gray2.color
        addViews()
        setDataSource()
        setNavBar()
        bind(reactor: reactor)
        // 초기 더미 데이터
        reactor.configureSnapshot(data: TripDummy.home.getTrips())
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeCollectionView.frame = view.bounds
    }
    
    // MARK: - Set UI
    private func addViews() {
        view.addSubview(homeCollectionView)
    }
    
    private func setCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        return layout
    }
    
    private func setDataSource() {
        homeCollectionView.register(
            HomeSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.identifier)
        homeCollectionView.register(HomeCollectionHeaderViewCell.self, forCellWithReuseIdentifier: HomeCollectionHeaderViewCell.identifier)
        homeCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        let comingCellRegistration = UICollectionView.CellRegistration<HomeCollectionViewCell, [Trip]> { cell, indexPath, trips in
            let trip = trips[indexPath.row]
            print("com = \(trips.count)")
            cell.configure(trip: trip)
        }
        let passedCellRegistration = UICollectionView.CellRegistration<HomeCollectionViewCell, [Trip]> { cell, indexPath, trips in
            let trip = trips[indexPath.row]
            print("pass = \(trips.count)")
            cell.configure(trip: trip)
        }
        
        reactor.dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeDataItem>(collectionView: homeCollectionView) { (collectionView, indexPath, homeItem) -> UICollectionViewCell? in
            switch homeItem {
            case .header:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionHeaderViewCell.identifier, for: indexPath) as? HomeCollectionHeaderViewCell else { return UICollectionViewCell() }
                return cell
            case .coming(let comingTrip):
                let cell = collectionView.dequeueConfiguredReusableCell(using: comingCellRegistration, for: indexPath, item: comingTrip)
                return cell
            case .passed(let passedTrip):
                let cell = collectionView.dequeueConfiguredReusableCell(using: passedCellRegistration, for: indexPath, item: passedTrip)
                return cell
            }
        }
        
        reactor.dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as? HomeSectionHeaderView else {
                    return UICollectionReusableView()
                }
                
                if indexPath.section == 1 {
                    header.sectionTitleLabel.text = "다가오는 여행"
                    return header
                }
                if indexPath.section == 2 {
                    header.sectionTitleLabel.text = "지난 여행"
                    return header
                }
                
                return header
            } else {
                return nil
            }
        }
        
        homeCollectionView.dataSource = reactor.dataSource
    }
    
    private func setNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width-40, height: 180)
        } else {
            return CGSize(width: UIScreen.main.bounds.width-40, height: 230)
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
