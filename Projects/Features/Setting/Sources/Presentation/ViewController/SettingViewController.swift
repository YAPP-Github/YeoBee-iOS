//
//  SettingViewController.swift
//  Setting
//
//  Created by 박현준 
//

import UIKit
import DesignSystem
import TravelRegistration
import Entity
import ReactorKit
import SnapKit
import RxSwift
import RxCocoa

enum SettingSection: String, CaseIterable {
    case companion = "함께 여행 중인 사람"
    case currency = "적용된 환율"
}

enum SettingDataItem: Hashable {
    case companion(Companion)
    case currency(SettingCurrency)
}

public final class SettingViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: SettingReactor
    private let coordinator: SettingCoordinator
    private var dataSource: UITableViewDiffableDataSource<SettingSection, SettingDataItem>?
    
    // MARK: - Properties
    private let settingHeaderView = SettingTableHeaderView(frame: CGRect(x: 0,
                                                                         y: 0,
                                                                         width: UIScreen.main.bounds.width,
                                                                         height: 270))
    private let settingTableView = SettingTableView(frame: .zero, style: .grouped)
    
    // MARK: - Life Cycles
    public init(coordinator: SettingCoordinator ,reactor: SettingReactor) {
        self.coordinator = coordinator
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setLayouts()
        setTableView()
        configureBar()
        setDataSource()
        bind(reactor: reactor)
        settingHeaderView.configure() // 임시 데이터 바인딩
        reactor.settingUseCase() // 임시 데이터 바인딩
    }
    
    // MARK: - Set UI
    private func addViews() {
        view.addSubview(settingTableView)
    }
    
    private func setLayouts() {
        settingTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource<SettingSection, SettingDataItem>(tableView: settingTableView)
        { (tableView, indexPath, settingDataItem) -> UITableViewCell? in
            
            switch settingDataItem {
            case .companion(let companion):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCompanionCell.identifier,
                                                               for: indexPath) as? SettingCompanionCell else { return UITableViewCell() }
                cell.delegate = self
                cell.companion = companion
                return cell
            case .currency(let currency):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCurrencyCell.identifier,
                                                               for: indexPath) as? SettingCurrencyCell else { return UITableViewCell() }
                cell.currency = currency
                return cell
            }
        }

        settingTableView.dataSource = dataSource
    }
    
    private func configureSnapshot(companions: [Companion], currencies: [SettingCurrency]) {
        var snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingDataItem>()
        snapshot.appendSections([.companion, .currency])
        snapshot.appendItems(companions.map { .companion($0) }, toSection: .companion)
        snapshot.appendItems(currencies.map { .currency($0) }, toSection: .currency)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setTableView() {
        settingTableView.delegate = self
        settingHeaderView.delegate = self
        settingTableView.tableHeaderView = settingHeaderView
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let trashImage = DesignSystemAsset.Icons.trash.image.withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        let trashButton = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(trashButtonTapped))
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = trashButton
    }
    
    @objc private func backButtonTapped() {
        coordinator.coordinatorDidFinish()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func trashButtonTapped() {
        print("여행 삭제")
    }

    deinit {
        print("SettingViewController is de-initialized.")
    }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingSection(rawValue: SettingSection.allCases[indexPath.section].rawValue) else {
            return UITableView.automaticDimension
        }
        
        switch section {
        case .companion:
            return 60
        case .currency:
            return 82
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SettingTableSectionHeaderView.identifier
        ) as? SettingTableSectionHeaderView else { return nil }
        
        sectionHeaderView.sectionTitleLabel.text = SettingSection.allCases[section].rawValue
        return sectionHeaderView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && reactor.currentState.companions.isEmpty {
            return .zero
        } else if section == 1 && reactor.currentState.currencies.isEmpty {
            return .zero
        } else {
            return 50
        }
    }
}

// MARK: - Bind
extension SettingViewController: View {
    public func bind(reactor: SettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingReactor) {
        
    }
    
    func bindState(reactor: SettingReactor) {
        reactor.state
            .map { $0.companions }
            .bind { [weak self] companions in
                guard let self else { return }
                let currentCurrencies = self.reactor.currentState.currencies
                self.configureSnapshot(companions: companions, currencies: currentCurrencies)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.currencies }
            .bind { [weak self] currencies in
                guard let self else { return }
                let currentCompanion = self.reactor.currentState.companions
                self.configureSnapshot(companions: currentCompanion, currencies: currencies)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 편집 버튼 Tap
extension SettingViewController: SettingTableHeaderViewDelegate {
    func modifyButtonTapped() {
        let settingBottomSheetViewController = SettingBottomSheetViewController()
        settingBottomSheetViewController.delegate = self
        presentBottomSheet(presentedViewController: settingBottomSheetViewController, height: 250)
    }
}

// MARK: - 바텀시트
extension SettingViewController: SettingBottomSheetViewControllerDelegate {
    func modifyTitleButtonTapped() {
        print("제목")
    }
    
    func modifyDateButtonTapped() {
        print("날짜")
    }
}

// MARK: - 동행자 edit버튼 Tap
extension SettingViewController: SettingCompanionCellDelegate {
    func editButtonTapped(companion: TravelRegistration.Companion) {
        let settingRecycleReactor = SettingRecycleReactor(viewType: .companionName)
        let settingRecycleViewController = SettingRecycleViewController(reactor: settingRecycleReactor)
        self.navigationController?.pushViewController(settingRecycleViewController, animated: true)
    }
}
