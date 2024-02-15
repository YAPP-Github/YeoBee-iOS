//
//  CalendarViewController.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import FSCalendar

public final class CalendarViewController: UIViewController {

    public var disposeBag = DisposeBag()
    private let reactor: CalendarReactor
    let coordinator: TravelRegistrationCoordinator
    
    private var dateformatter: DateFormatter = {
        $0.dateFormat = "MM.dd E"
        $0.locale = Locale(identifier: "ko_KR")
        return $0
    }(DateFormatter())
    
    // MARK: - Properties
    private let registerLabel = YBLabel(text: "여행일정을 등록해주세요.", 
                                        font: .header2,
                                        textColor: .black,
                                        textAlignment: .left)
    private lazy var periodLabel = YBPaddingLabel(text: " - ",
                                                  backgroundColor: .brightGreen,
                                                  textColor: .mainGreen,
                                                  borderColor: .mediumGreen,
                                                  font: .body2,
                                                  padding: .small)
    private let calendarView = CalendarView()
    private let dividerView = YBDivider(height: 0.6, 
                                        color: .gray3)
    private let nextButton = YBTextButton(text: "다음으로", 
                                          appearance: .defaultDisable,
                                          size: .medium)
    
    // MARK: - Life Cycles
    init(coordinator: TravelRegistrationCoordinator, reactor: CalendarReactor) {
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
        setDelegate()
        configureBar()
        bind(reactor: reactor)
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            registerLabel,
            periodLabel,
            calendarView,
            dividerView,
            nextButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(24)
        }
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).inset(-18)
            make.leading.equalTo(registerLabel.snp.leading)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).inset(-16)
            make.leading.trailing.equalToSuperview()
        }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).inset(-26)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(dividerView.snp.top)
        }
    }
    
    private func setDelegate() {
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("deinit CalendarViewController")
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        configureCalenderHeaderText()
    }
    
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 아무 날짜 선택되지 않은 경우
        if reactor.currentState.startDate == nil {
            reactor.action.onNext(.startDate(date: date))
            configureVisibleCells()
            return
        }
        
        // 시작 날짜만 선택된 경우
        if reactor.currentState.startDate != nil && reactor.currentState.endDate == nil {
            // 마지막 날짜가 시작날짜보다 작을 경우
            if let currentStartDate = reactor.currentState.startDate {
                if date <= currentStartDate {
                    calendarView.calendar.deselect(currentStartDate)
                    reactor.action.onNext(.startDate(date: date))
                    configureVisibleCells()
                    return
                }
                
                let range = datesRange(from: currentStartDate, to: date)
                
                if let currentLastDate = range.last {
                    reactor.action.onNext(.endDate(date: currentLastDate))
                    
                    for selectedDate in range {
                        calendar.select(selectedDate)
                    }
                    
                    reactor.action.onNext(.selectedDate(dates: range))
                    configureVisibleCells()
                    return
                }
            }
        }
        
        // 시작, 마지막 날짜 모두 선택된 경우
        if reactor.currentState.startDate != nil && reactor.currentState.endDate != nil {
            clearSelectedDates(in: calendar)
        }
        configureVisibleCells()
    }
    
    
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: YBCalendarCell.identifier, for: date, at: position)
        return cell
    }
    
    public func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: monthPosition)
    }
    
    public func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == FSCalendarMonthPosition.current
    }
    
    public func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
    }
    
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let koreanHolidays: Set<String> = [
            "01-01",
            "03-01",
            "05-05",
            "06-06",
            "08-15",
            "10-03",
            "12-25"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if koreanHolidays.contains(dateString) || Calendar.current.component(.weekday, from: date) == 1 {
            return YBColor.mainRed.color
        } else {
            return YBColor.black.color
        }
    }
}

// MARK: - 헤더 / 날짜 설정
extension CalendarViewController {
    private func configureCalenderHeaderText() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        let currentPage = calendarView.calendar.currentPage
        calendarView.monthHeaderLabel.text = formatter.string(from: currentPage)
    }
    
    private func updatePeriodLabel(startDate: Date?, endDate: Date?) {
        guard let startDate = startDate else { return periodLabel.text = " - " }
        let startDateString = dateformatter.string(from: startDate)
        guard let endDate = endDate else { return periodLabel.text = "\(startDateString) - " }
        let endDateString = dateformatter.string(from: endDate)
        periodLabel.text = "\(startDateString) - \(endDateString)"
    }
}

// MARK: - 캘린더 설정
extension CalendarViewController {
    private func clearSelectedDates(in calendar: FSCalendar) {
        calendar.selectedDates.forEach { calendar.deselect($0) }
        reactor.action.onNext(.startDate(date: nil))
        reactor.action.onNext(.endDate(date: nil))
        reactor.action.onNext(.selectedDate(dates: []))
    }
    
    private func configureVisibleCells() {
        calendarView.calendar.visibleCells().forEach { (cell) in
            let date = calendarView.calendar.date(for: cell)
            let position = calendarView.calendar.monthPosition(for: cell)
            guard let unwrappedDate = date else { return }
            self.configure(cell: cell, for: unwrappedDate, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let diyCell = (cell as? YBCalendarCell) else { return }
        diyCell.circleImageView?.isHidden = true
        var selectionType = SelectionType.none
        let selectedDates = calendarView.calendar.selectedDates.sorted()
        
        // 두 개 선택 시
        if selectedDates.count == 2 {
            let first = selectedDates[0]
            let second = selectedDates[1]
            
            if date == first {
                selectionType = .leftBorder
            } else if date == second {
                selectionType = .rightBorder
            } else if date > first && date < second {
                selectionType = .middle
            }
            // 여러 개 선택 시
        } else if selectedDates.count > 2 {
            if date > selectedDates.first ?? Date() && date < selectedDates.last ?? Date() {
                selectionType = .middle
                diyCell.titleLabel.textColor = YBColor.mainGreen.color
            } else if date == selectedDates.last {
                selectionType = .rightBorder
            } else if date == selectedDates.first {
                selectionType = .leftBorder
            }
        } else {
            if calendarView.calendar.selectedDates.contains(date) {
                // 하나 선택 시
                if calendarView.calendar.selectedDates.count == 1 {
                    selectionType = .single
                } else {
                    selectionType = .none
                }
            } else {
                selectionType = .none
            }
        }
        
        diyCell.selectionLayer?.isHidden = false
        diyCell.selectionType = selectionType
    }
    
    private func datesRange(from startDate: Date, to endDate: Date) -> [Date] {
        guard startDate <= endDate else { return [] }
        
        var currentDate = startDate
        var dates = [currentDate]
        
        while currentDate < endDate {
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { break }
            dates.append(nextDate)
            currentDate = nextDate
        }
        return dates
    }
}

// MARK: - Bind
extension CalendarViewController: View {
    public func bind(reactor: CalendarReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CalendarReactor) {
        nextButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self else { return }
                if let startDate = self.reactor.currentState.startDate {
                    let endDate = self.reactor.currentState.endDate ?? startDate
                    
                    let tripRequest = RegistTripRequest(
                        title: "",
                        startDate: self.reactor.formatDateToString(startDate),
                        endDate: self.reactor.formatDateToString(endDate),
                        countryList: self.reactor.currentState.tripRequest.countryList,
                        tripUserList: [])
                    
                    let companionReactor = CompanionReactor(tripRequest: tripRequest)
                    let companionViewController = CompanionViewController(coordinator: self.coordinator,
                                                                          reactor: companionReactor)
                    self.navigationController?.pushViewController(companionViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: CalendarReactor) {
        reactor.state
            .map { $0.startDate }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] startDate in
                self?.updatePeriodLabel(startDate: startDate, endDate: nil)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.endDate }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] endDate in
                self?.updatePeriodLabel(startDate: reactor.currentState.startDate, endDate: endDate)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedDate }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] selectedDate in
                if selectedDate.isEmpty {
                    self?.nextButton.isEnabled = false
                    self?.nextButton.setTitle("다음으로", for: .normal)
                    self?.nextButton.setAppearance(appearance: .defaultDisable)
                } else {
                    self?.nextButton.isEnabled = true
                    self?.nextButton.setTitle("다음으로", for: .normal)
                    self?.nextButton.setAppearance(appearance: .default)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.checkedDateValidation }
            .observe(on: MainScheduler.instance)
            .bind { isOverlap in
                if isOverlap {
                    print("여행이 겹쳤어요 - alert")
                }
            }
            .disposed(by: disposeBag)
    }
}
