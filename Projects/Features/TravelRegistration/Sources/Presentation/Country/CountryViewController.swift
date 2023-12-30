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

public final class CountryViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor = CountryReactor()
    // MARK: - Properties
    let countryTableView: UITableView = {
        $0.separatorInset.left = 0
        $0.rowHeight = 50
        return $0
    }(UITableView())
    let horizontalContryView = HorizontalContryView()
    let selectedCountryView = SelectedCountryView()
    let dividerView = YBDivider(height: 0.6, color: .gray3)
    let secondDividerView = YBDivider(height: 0.6, color: .gray3)
    let nextButton = YBTextButton(text: "다음으로", appearance: .defaultDisable, size: .medium)
    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavSearchBar()
        addViews()
        setLayouts()
        setDelegate()
        setDataSource()
        bind(reactor: reactor)
        // 초기 데이터 임시
        reactor.configureSnapshot(type: .total, data: CountryType.total.getCountries())
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            horizontalContryView,
            countryTableView,
            selectedCountryView,
            dividerView,
            secondDividerView,
            nextButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        horizontalContryView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
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
        secondDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(selectedCountryView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        countryTableView.snp.makeConstraints { make in
            make.top.equalTo(horizontalContryView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(secondDividerView.snp.top)
        }
    }
    
    private func setDelegate() {
        selectedCountryView.selectedCountryViewDelegate = self
    }
    
    private func setNavSearchBar() {
        let sc = UIScreen.main.bounds.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: sc, height: 0))
        searchBar.searchTextField.textColor = YBColor.black.color
        searchBar.searchTextField.font = YBFont.body2.font
        searchBar.searchTextField.backgroundColor  = YBColor.gray2.color
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "찾으시는 국가명을 입력해주세요.",
            attributes: [
                NSAttributedString.Key.foregroundColor: YBColor.gray5.color,
                NSAttributedString.Key.font: YBFont.body2.font
            ]
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    private func setDataSource() {
        countryTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        reactor.dataSource = UITableViewDiffableDataSource<CountrySection, Country>(tableView: self.countryTableView) { (tableView: UITableView, indexPath: IndexPath, country: Country) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as? CountryTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.country = country
            
            if self.reactor.currentState.selectedCountries.contains(where: { $0.name == country.name }) {
                cell.checkedButtonSelected = true
            }
            return cell
        }
        countryTableView.dataSource = reactor.dataSource
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
            .map { $0.selectedCountries }
            .observe(on: MainScheduler.instance)
            .bind(to: selectedCountryView.rx.selectedCountries)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.deletedCountry }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] country in
                guard let country = country,
                      let self = self else { return }
                
                if let visibleCells = self.countryTableView.visibleCells as? [CountryTableViewCell] {
                    for cell in visibleCells {
                        if cell.country == country {
                            cell.checkedButtonSelected = false
                        }
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func getSectionIndex(for type: CountryType) -> Int {
        switch type {
        case .total:
            return 0
        case .europe:
            return 1
        case .asia:
            return 2
        case .northAmerica:
            return 3
        case .southAmerica:
            return 4
        case .africa:
            return 5
        }
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
