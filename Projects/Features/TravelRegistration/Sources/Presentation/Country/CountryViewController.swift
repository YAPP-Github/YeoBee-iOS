//
//  CountryViewController.swift
//  TravelRegistration
//
//  Created by 박현준 
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

enum CountrySection: String, CaseIterable {
    case europe = "유럽"
    case asia = "아시아"
    case northAmerica = "북아메리카"
    case southAmerica = "남아메리카"
    case africa = "아프리카"
}

enum CountryDataItem: Hashable {
    case europe(Country)
    case asia(Country)
    case northAmerica(Country)
    case southAmerica(Country)
    case africa(Country)
}

public final class CountryViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: CountryReactor
    private var dataSource: UITableViewDiffableDataSource<CountrySection, CountryDataItem>?
    private let coordinator: CountryCoordinator
    
    // MARK: - Properties
    private let countryTableView = CountryTableView()
    private let horizontalCountryView = HorizontalCountryView()
    private let selectedCountryView = SelectedCountryView()
    private let dividerView = YBDivider(height: 0.6, color: .gray3)
    private let nextButton = YBTextButton(text: "다음으로", appearance: .defaultDisable, size: .medium)
    
    // MARK: - Life Cycles
    public init(coordinator: CountryCoordinator, reactor: CountryReactor) {
        self.reactor = reactor
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavSearchBar()
        configureBar()
        addViews()
        setLayouts()
        setDelegate()
        setDataSource()
        hideKeyboardWhenTappedAround()
        bind(reactor: reactor)
        reactor.viewDidLoad()
    }

    // MARK: - Set UI
    private func addViews() {
        [
            horizontalCountryView,
            countryTableView,
            selectedCountryView,
            dividerView,
            nextButton
        ].forEach {
            view.addSubview($0)
        }
    }

    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        coordinator.coordinatorDidFinish()
    }

    private func setLayouts() {
        horizontalCountryView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
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
            make.top.equalTo(horizontalCountryView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(dividerView.snp.top)
        }
    }
    
    private func setSelectedCountryViewLayout(isEmpty: Bool) {
        if isEmpty {
            selectedCountryView.alpha = 0
            countryTableView.snp.remakeConstraints { make in
                make.top.equalTo(horizontalCountryView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(dividerView.snp.top)
            }
        } else {
            selectedCountryView.alpha = 1
            countryTableView.snp.remakeConstraints { make in
                make.top.equalTo(horizontalCountryView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(selectedCountryView.snp.top)
            }
        }
    }
    
    private func setDelegate() {
        countryTableView.delegate = self
        selectedCountryView.selectedCountryViewDelegate = self
    }
    
    private func setNavSearchBar() {
        let sc = UIScreen.main.bounds.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: sc, height: 0))
        searchBar.delegate = self
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
        dataSource = UITableViewDiffableDataSource<CountrySection, CountryDataItem>(tableView: self.countryTableView) { [weak self] (tableView, indexPath, countryDataItem) -> UITableViewCell? in
            var country: Country
            switch countryDataItem {
            case .europe(let europeCountry):
                country = europeCountry
            case .asia(let asiaCountry):
                country = asiaCountry
            case .northAmerica(let naCountry):
                country = naCountry
            case .southAmerica(let saCountry):
                country = saCountry
            case .africa(let africaCountry):
                country = africaCountry
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as? CountryTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.country = country
            
            if let self,
               self.reactor.currentState.selectedCountries.contains(where: { $0 == country }) {
                cell.checkedButtonSelected = true
            }
            return cell
        }

        countryTableView.dataSource = dataSource
    }
    
    func configureSnapshot(dc: DataCountry) {
        var snapshot = NSDiffableDataSourceSnapshot<CountrySection, CountryDataItem>()
        snapshot.appendSections([.europe, .asia, .northAmerica, .southAmerica, .africa])
        snapshot.appendItems(dc.europe.map { .europe($0) }, toSection: .europe)
        snapshot.appendItems(dc.asia.map { .asia($0) }, toSection: .asia)
        snapshot.appendItems(dc.northAmerica.map { .northAmerica($0) }, toSection: .northAmerica)
        snapshot.appendItems(dc.southAmerica.map { .southAmerica($0) }, toSection: .southAmerica)
        snapshot.appendItems(dc.africa.map { .africa($0) }, toSection: .africa)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        navigationController?.view.endEditing(true)
    }

    deinit {
        print("deinit CountryViewController")
        coordinator.coordinatorDidFinish()
    }
}

// MARK: - UITableViewDelegate
extension CountryViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let countrySection = CountrySection.allCases[section]
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CountrySectionHeaderView.identifier) as? CountrySectionHeaderView else { return nil }
        headerView.sectionTitleLabel.text = countrySection.rawValue
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dataCountry = self.reactor.currentState.countries
        let sectionArray = [
            dataCountry.europe,
            dataCountry.asia,
            dataCountry.northAmerica,
            dataCountry.southAmerica,
            dataCountry.africa
        ]
        
        return sectionArray[section].isEmpty ? CGFloat.leastNormalMagnitude : 60
    }
}

// MARK: - UISearchBarDelegate
extension CountryViewController: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 다른 카테고리였다가 searchBar 타겟 시 전체 버튼 탭
        if horizontalCountryView.selectedButton?.titleLabel?.text == CountryType.total.rawValue {
            return
        } else {
            horizontalCountryView.totalButtonTapped()
        }
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
        
        for button in horizontalCountryView.stackView.arrangedSubviews {
            if let button = button as? UIButton {
                button.rx.tap
                    .map { Reactor.Action.typeButtonTapped(title: button.title(for: .normal) ?? "") }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            }
        }
        
        nextButton.rx.tap
            .bind { [weak self] _ in
                let selectedCountries = reactor.currentState.selectedCountries
                    .map { CountryAndTripUserItemRequest(name: $0.name) }
                
                let tripRequest = TripRequest(
                    title: "",
                    startDate: "",
                    endDate: "",
                    countryList: selectedCountries,
                    tripUserList: []
                )
                self?.coordinator.calendar(tripRequest: tripRequest)
            }.disposed(by: disposeBag)
    }
    
    func bindState(reactor: CountryReactor) {
        reactor.state
            .map { $0.countries }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] dataCountry in
                self?.configureSnapshot(dc: dataCountry)
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
            }.disposed(by: disposeBag)
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
