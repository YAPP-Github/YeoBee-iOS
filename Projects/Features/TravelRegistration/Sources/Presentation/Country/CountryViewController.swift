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
    case asia = "아시아"
    case europe = "유럽"
    case oceania = "오세아니아"
    case america = "아메리카"
    case africa = "아프리카"
}

enum CountryDataItem: Hashable {
    case asia(Country)
    case europe(Country)
    case oceania(Country)
    case america(Country)
    case africa(Country)
}

public final class CountryViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: CountryReactor
    private var dataSource: UITableViewDiffableDataSource<CountrySection, CountryDataItem>?
    private let coordinator: TravelRegistrationCoordinator
    
    // MARK: - Properties
    private let countryTableView = CountryTableView()
    private let horizontalCountryView = HorizontalCountryView()
    private let selectedCountryView = SelectedCountryView()
    private let topEmptyView = YBDivider(height: 10, color: .white)
    private let topDividerView = YBDivider(height: 0.6, color: .gray3)
    private let bottomDividerView = YBDivider(height: 0.6, color: .gray3)
    private let nextButton = YBTextButton(text: "다음으로", appearance: .defaultDisable, size: .medium)
    private let emptyView = YBEmptyView(title: "검색 결과가 없어요.")
    
    // MARK: - Life Cycles
    public init(coordinator: TravelRegistrationCoordinator, reactor: CountryReactor) {
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
        configureBar()
        addViews()
        setLayouts()
        setDelegate()
        setDataSource()
        hideKeyboardWhenTappedAround()
        bind(reactor: reactor)
        reactor.countriesUseCase()
    }

    // MARK: - Set UI
    private func addViews() {
        [
            horizontalCountryView,
            countryTableView,
            selectedCountryView,
            topEmptyView,
            topDividerView,
            bottomDividerView,
            nextButton,
            emptyView
        ].forEach {
            view.addSubview($0)
        }
    }

    private func setLayouts() {
        horizontalCountryView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(65)
        }
        topEmptyView.snp.makeConstraints { make in
            make.top.equalTo(horizontalCountryView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        topDividerView.snp.makeConstraints { make in
            make.top.equalTo(topEmptyView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        bottomDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).inset(-16)
            make.leading.trailing.equalToSuperview()
        }
        selectedCountryView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomDividerView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(111)
        }
        countryTableView.snp.makeConstraints { make in
            make.top.equalTo(horizontalCountryView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomDividerView.snp.top)
        }
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(countryTableView.snp.edges)
        }
    }
    
    private func setSelectedCountryViewLayout(isEmpty: Bool) {
        if isEmpty {
            selectedCountryView.alpha = 0
            countryTableView.snp.remakeConstraints { make in
                make.top.equalTo(horizontalCountryView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(bottomDividerView.snp.top)
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
    
    private func configureBar() {
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
        
        let backImage = UIImage(systemName: "xmark")?
            .withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = searchBar
        
        searchBar.rx.text
            .map { Reactor.Action.searchBarText(text: $0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource<CountrySection, CountryDataItem>(tableView: self.countryTableView) { [weak self] (tableView, indexPath, countryDataItem) -> UITableViewCell? in
            var country: Country
            switch countryDataItem {
            case .europe(let europeCountry):
                country = europeCountry
            case .asia(let asiaCountry):
                country = asiaCountry
            case .america(let americaCountry):
                country = americaCountry
            case .oceania(let oceaniaCountry):
                country = oceaniaCountry
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
        snapshot.appendSections([.asia, .europe, .oceania, .america, .africa])
        snapshot.appendItems(dc.asia.map { .asia($0) }, toSection: .asia)
        snapshot.appendItems(dc.europe.map { .europe($0) }, toSection: .europe)
        snapshot.appendItems(dc.oceania.map { .oceania($0) }, toSection: .oceania)
        snapshot.appendItems(dc.america.map { .america($0) }, toSection: .america)
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
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true)
        coordinator.coordinatorDidFinish()
    }

    deinit {
        print("deinit CountryViewController")
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
            dataCountry.asia,
            dataCountry.europe,
            dataCountry.oceania,
            dataCountry.america,
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
                guard let self else { return }
                let selectedCountries = self.reactor.currentState.selectedCountries
                    .map { CountryItemRequest(name: $0.name) }
                
                let tripRequest = RegistTripRequest(
                    title: "",
                    startDate: "",
                    endDate: "",
                    countryList: selectedCountries,
                    tripUserList: []
                )
                
                let calendarReactor = CalendarReactor(tripRequest: tripRequest)
                let calendarViewController = CalendarViewController(coordinator: self.coordinator, reactor: calendarReactor)
                self.navigationController?.pushViewController(calendarViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CountryReactor) {
        reactor.state
            .map { $0.countries }
            .do(onNext: { [weak self] dataCountry in
                self?.emptyView.isHidden = (!dataCountry.africa.isEmpty ||
                                            !dataCountry.asia.isEmpty ||
                                            !dataCountry.europe.isEmpty ||
                                            !dataCountry.america.isEmpty ||
                                            !dataCountry.oceania.isEmpty)
            })
            .observe(on: MainScheduler.instance)
            .bind { [weak self] dataCountry in
                self?.configureSnapshot(dc: dataCountry)
            }
            .disposed(by: disposeBag)
        
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
        
        reactor.state
            .map { $0.makeLimitToast }
            .observe(on: MainScheduler.instance)
            .bind { makeToast in
                if makeToast {
                    let toast = Toast.text(icon: .warning, "최대 20개 나라를 선택할 수 있어요.")
                    toast.show()
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
