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
    case main
}

public class HomeViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    let reactor = HomeReactor()
    // MARK: - Properties
    lazy var homeCollectionView: UICollectionView = {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
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
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-40, height: 230)
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 180)
        return layout
    }
    
    private func setDataSource() {
        homeCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        homeCollectionView.register(
            HomeCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionHeaderView.identifier
        )
        
        reactor.dataSource = UICollectionViewDiffableDataSource<HomeSection, Trip>(collectionView: self.homeCollectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
            cell.configure()
            return cell
        }
        
        reactor.dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let self = self,
                      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeCollectionHeaderView.identifier, for: indexPath) as? HomeCollectionHeaderView else {
                    return HomeCollectionHeaderView()
                }
                // MARK: [TODO] 헤더뷰 안에 프로필 데이터 넣기
                header.chevronButton.rx.tap
                    .bind { _ in
                        print("move to profile")
                    }.disposed(by: disposeBag)
                
                header.addTripView.rx.tapGesture()
                    .when(.recognized)
                    .bind { _ in
                        print("make new trip")
                    }.disposed(by: self.disposeBag)
                
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
