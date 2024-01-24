//
//  CompanionViewController.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

enum CompanionSection: CaseIterable {
    case main
}

enum CompanionDataItem: Hashable {
    case main(Companion)
}

public enum CompanionType: CaseIterable {
    case none
    case companion
    case alone
}

public final class CompanionViewController: UIViewController {

    public var disposeBag = DisposeBag()
    private let reactor = CompanionReactor()
    private var dataSource: UITableViewDiffableDataSource<CompanionSection, CompanionDataItem>?
    
    // MARK: - Properties
    private let titleLabel = YBLabel(text: "여행을 함께 하는 동행이 있나요?", font: .header2, textColor: .black)
    private let subTitleLabel = YBLabel(text: "나중에 변경이 어려워요.", font: .body2, textColor: .gray5)
    var companionButton = YBTextButton(text: "있어요", appearance: .selectDisable, size: .medium)
    let aloneButton = YBTextButton(text: "혼자가요", appearance: .selectDisable, size: .medium)
    private let buttonStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .center
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    private let addCompanionView = AddCompanionView()
    private let companionTableView = CompanionTableView()
    private let dividerView = YBDivider(height: 0.6,
                                        color: .gray3)
    private var nextButton = YBTextButton(text: "다음으로",
                                          appearance: .defaultDisable,
                                          size: .medium)
    
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setLayouts()
        bind(reactor: reactor)
        setDataSource()
        addCompanionView.configure() // 임시 내 프로필 데이터 설정
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            titleLabel,
            subTitleLabel,
            buttonStackView,
            addCompanionView,
            companionTableView,
            dividerView,
            nextButton
        ].forEach {
            view.addSubview($0)
        }
        
        [
            companionButton,
            aloneButton
        ].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(24)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-6)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        addCompanionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).inset(-30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(105)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).inset(-16)
            make.leading.trailing.equalToSuperview()
        }
        companionTableView.snp.makeConstraints { make in
            make.top.equalTo(addCompanionView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(dividerView.snp.top)
        }
    }
    
    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource<CompanionSection, CompanionDataItem>(tableView: self.companionTableView) 
        { [weak self] (tableView, indexPath, companionDataItem) -> UITableViewCell? in
            guard let self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: CompanionTableViewCell.identifier,
                                                           for: indexPath) as? CompanionTableViewCell else { return UITableViewCell() }
            
            var companion: Companion
            switch companionDataItem {
            case .main(let mainCompanion):
                companion = mainCompanion
            }
            
            cell.delegate = self
            cell.companion = companion
            return cell
        }

        companionTableView.dataSource = dataSource
    }
    
    private func configureSnapshot(companions: [Companion]) {
        var snapshot = NSDiffableDataSourceSnapshot<CompanionSection, CompanionDataItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(companions.map { .main($0) }, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        // 테이블 뷰 들어온 셀 자동 스크롤
        if !companions.isEmpty {
            let lastIndexPath = IndexPath(row: companions.count - 1, section: 0)
            companionTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }

    deinit {
        print("deinit CompanionViewController")
    }
}

// MARK: - CompanionTableViewCellDelegate
extension CompanionViewController: CompanionTableViewCellDelegate {
    func changeCompanionName(companion: Companion) {
        guard let indexPath = dataSource?.indexPath(for: .main(companion)) else { return }
        
        let changeCompanionNameReactor = ChangeCompanionNameReactor(companion: companion, index: indexPath)
        let changeCompanionNameVC = ChangeCompanionNameViewController(reactor: changeCompanionNameReactor)
        changeCompanionNameVC.delegate = self
        self.navigationController?.pushViewController(changeCompanionNameVC, animated: true)
    }
    
    func deleteCompanion(companion: Companion) {
        Observable.just(companion)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] companion in
                self?.reactor.action.onNext(.deleteCompanion(companion))
            }.disposed(by: disposeBag)
    }
}

// MARK: - Bind
extension CompanionViewController: View {
    public func bind(reactor: CompanionReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CompanionReactor) {
        companionButton.rx.tap
            .map { Reactor.Action.companionType(.companion) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        aloneButton.rx.tap
            .map { Reactor.Action.companionType(.alone) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addCompanionView.addCompanionButton.rx.tap
            .map { Reactor.Action.addCompanion }
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] _ in
                let travelTitleReactor = TravelTitleReactor()
                let travelTitleViewController = TravelTitleViewController(reactor: travelTitleReactor)
                self?.navigationController?.pushViewController(travelTitleViewController, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func bindState(reactor: CompanionReactor) {
        reactor.state
            .map { $0.companions }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] companions in
                self?.configureSnapshot(companions: companions)
                if companions.isEmpty {
                    self?.nextButton.setTitle("다음으로", for: .normal)
                    self?.nextButton.isEnabled = false
                    self?.nextButton.setAppearance(appearance: .defaultDisable)
                } else {
                    self?.nextButton.setTitle("다음으로", for: .normal)
                    self?.nextButton.isEnabled = true
                    self?.nextButton.setAppearance(appearance: .default)
                }
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.companionType }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] companionType in

                switch companionType {
                case .none:
                    self?.addCompanionView.alpha = 0
                    self?.companionTableView.alpha = 0
                case .companion:
                    self?.addCompanionView.alpha = 1
                    self?.companionTableView.alpha = 1
                    self?.companionButton.setTitle("있어요", for: .normal)
                    self?.companionButton.setAppearance(appearance: .select)
                    self?.aloneButton.setTitle("혼자가요", for: .normal)
                    self?.aloneButton.setAppearance(appearance: .selectDisable)
                    if let reactor = self?.reactor,
                       reactor.currentState.companions.isEmpty {
                        self?.nextButton.setTitle("다음으로", for: .normal)
                        self?.nextButton.isEnabled = false
                        self?.nextButton.setAppearance(appearance: .defaultDisable)
                    }
                case .alone:
                    self?.addCompanionView.alpha = 0
                    self?.companionTableView.alpha = 0
                    self?.companionButton.setTitle("있어요", for: .normal)
                    self?.companionButton.setAppearance(appearance: .selectDisable)
                    self?.aloneButton.setTitle("혼자가요", for: .normal)
                    self?.aloneButton.setAppearance(appearance: .select)
                    self?.nextButton.setTitle("다음으로", for: .normal)
                    self?.nextButton.isEnabled = true
                    self?.nextButton.setAppearance(appearance: .default)
                }
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.makeLimitToast }
            .observe(on: MainScheduler.instance)
            .bind { makeToast in
                if makeToast {
                    let toast = Toast.text(icon: .warning, "최대 10명까지 추가할 수 있어요.")
                    toast.show()
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - ChangeCompanionNameViewControllerDelegate
extension CompanionViewController: ChangeCompanionNameViewControllerDelegate {
    func modifyCompanionName(companion: Companion, index: IndexPath) {
        reactor.action.onNext(.updateCompanion(companion, index))
    }
}
