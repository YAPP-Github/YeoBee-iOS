//
//  CountryViewController.swift
//  TravelRegistration
//
//  Created by 박현준 
//

import UIKit
import DesignSystem
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

enum CountrySection: CaseIterable {
    case main
}

public final class CountryViewController: TravelRegistrationController {
    
    public var disposeBag = DisposeBag()
    private let reactor = CountryReactor()
    var dataSource: UITableViewDiffableDataSource<CountrySection, Country>!
    // MARK: - Properties
    let countryTableView = CountryTableView()
    let horizontalContryView = HorizontalContryView()
    let selectedCountryView = SelectedCountryView()
    let dividerView = YBDivider(height: 0.6, color: .gray3)
    let nextButton = YBTextButton(text: "다음으로", appearance: .defaultDisable, size: .medium)
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setNavSearchBar()
        addViews()
        setLayouts()
        setDelegate()
        setDataSource()
        bind(reactor: reactor)
        reactor.viewDidLoad()
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            horizontalContryView,
            countryTableView,
            selectedCountryView,
            dividerView,
            nextButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        horizontalContryView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(76)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).inset(-16)
            make.leading.trailing.equalToSuperview()
        }
        selectedCountryView.snp.makeConstraints { make in
            make.bottom.equalTo(dividerView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(111)
        }
        countryTableView.snp.makeConstraints { make in
            make.top.equalTo(horizontalContryView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(dividerView.snp.top)
        }
    }
    
    private func setSelectedCountryViewLayout(isEmpty: Bool) {
        if isEmpty {
            selectedCountryView.alpha = 0
            countryTableView.snp.remakeConstraints { make in
                make.top.equalTo(horizontalContryView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(dividerView.snp.top)
            }
        } else {
            selectedCountryView.alpha = 1
            countryTableView.snp.remakeConstraints { make in
                make.top.equalTo(horizontalContryView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(selectedCountryView.snp.top)
            }
        }
    }
    
    private func setDelegate() {
        selectedCountryView.selectedCountryViewDelegate = self
    }
    
    private func setNavSearchBar() {
        let sc = UIScreen.main.bounds.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: sc, height: 0))
        searchBar.searchTextField.textColor = YBColor.black.color
        searchBar.searchTextField.font = YBFont.body1.font
        searchBar.searchTextField.backgroundColor  = YBColor.gray2.color
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "찾으시는 국가명을 입력해주세요.",
            attributes: [
                NSAttributedString.Key.foregroundColor: YBColor.gray5.color,
                NSAttributedString.Key.font: YBFont.body1.font
            ]
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource<CountrySection, Country>(tableView: self.countryTableView) { (tableView: UITableView, indexPath: IndexPath, country: Country) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as? CountryTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.country = country
            
            if self.reactor.currentState.selectedCountries.contains(where: { $0.name == country.name }) {
                cell.checkedButtonSelected = true
            }
            return cell
        }
        countryTableView.dataSource = dataSource
    }
    
    func configureSnapshot(data: [Country]) {
        var snapshot = NSDiffableDataSourceSnapshot<CountrySection, Country>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CountryViewController: View {
    public func bind(reactor: CountryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    // MARK: - Bind
    func bindAction(reactor: CountryReactor) {
        if let searchBar = self.navigationItem.rightBarButtonItem?.customView as? UISearchBar {
            searchBar.rx.text
                .map { Reactor.Action.searchBarText(text: $0 ?? "") }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        
        for button in horizontalContryView.stackView.arrangedSubviews {
            if let button = button as? UIButton {
                button.rx.tap
                    .map { Reactor.Action.typeButtonTapped(title: button.title(for: .normal) ?? "") }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            }
        }
        
        nextButton.rx.tap
            .bind { _ in
                reactor.action.onNext(Reactor.Action.nextButtonTapped)
            }.disposed(by: disposeBag)
    }
    
    func bindState(reactor: CountryReactor) {
        reactor.state
            .map { $0.countries }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] countries in
                self?.configureSnapshot(data: countries)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedCountries }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] selectedCountries in
                self?.selectedCountryView.selectedCountries = selectedCountries
                // 선택 해제 시 테이블 뷰 셀도 선택 해제
                if let cells = self?.countryTableView.visibleCells as? [CountryTableViewCell] {
                    for cell in cells {
                        if let country = cell.country, !selectedCountries.contains(country) {
                            cell.checkedButtonSelected = false
                        }
                    }
                }
                
                if selectedCountries.isEmpty {
                    self?.nextButton.setTitle("다음으로", for: .normal)
                    self?.nextButton.setAppearance(appearance: .defaultDisable)
                    self?.nextButton.isEnabled = false
                    self?.setSelectedCountryViewLayout(isEmpty: true)
                } else {
                    self?.nextButton.setTitle("다음으로", for: .normal)
                    self?.nextButton.setAppearance(appearance: .default)
                    self?.nextButton.isEnabled = true
                    self?.setSelectedCountryViewLayout(isEmpty: false)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CountryTableViewCellDelegate
extension CountryViewController: CountryTableViewCellDelegate {
    func checkedButtonTapped(country: Country) {
        reactor.action.onNext(.checkedButtonTapped(country: country))
    }
}

// MARK: - SelectedCountryViewDelegate
extension CountryViewController: SelectedCountryViewDelegate {
    func deleteCountry(country: Country) {
        reactor.action.onNext(.deletedCountry(country: country))
    }
}
