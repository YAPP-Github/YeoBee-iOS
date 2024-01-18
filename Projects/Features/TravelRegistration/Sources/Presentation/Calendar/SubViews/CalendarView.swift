//
//  CalendarView.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import FSCalendar
import RxSwift
import RxCocoa

class CalendarView: UIView {
    var disposeBag = DisposeBag()
    
    private let dividerView = YBDivider(height: 0.6, color: .gray3)
    lazy var monthHeaderLabel = YBLabel(text: dateformatter.string(from: Date()), font: .body1, textColor: .black)
    private let previousMonthButton = YBIconButton(image: UIImage(systemName:"chevron.backward"), tintColor: .black)
    private let nextMonthButton = YBIconButton(image: UIImage(systemName:"chevron.forward"), tintColor: .black)
    
    lazy var calendar: FSCalendar = {
        $0.locale = Locale(identifier: "ko_KR")
        $0.allowsMultipleSelection = true
        $0.headerHeight = 0
        $0.appearance.headerTitleColor = .clear
        $0.appearance.headerMinimumDissolvedAlpha = 0
        $0.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
        $0.appearance.titleTodayColor = YBColor.black.color
        $0.appearance.weekdayTextColor = YBColor.black.color
        $0.appearance.weekdayFont = YBFont.title1.font
        $0.appearance.titleFont = YBFont.title1.font
        $0.calendarWeekdayView.weekdayLabels[0].textColor = YBColor.mainRed.color
        $0.calendarWeekdayView.backgroundColor = .clear
        $0.placeholderType = .none
        $0.register(YBCalendarCell.self, forCellReuseIdentifier: YBCalendarCell.identifier)
        return $0
    }(FSCalendar())
    
    private var dateformatter: DateFormatter = {
        $0.dateFormat = "yyyy년 MM월"
        $0.locale = Locale(identifier: "ko_KR")
        return $0
    }(DateFormatter())
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addViews()
        setLayouts()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // MARK: - Set UI
    private func setView() {
        backgroundColor = YBColor.gray1.color
    }
    
    private func addViews() {
        [
            dividerView,
            previousMonthButton,
            monthHeaderLabel,
            nextMonthButton,
            calendar
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        dividerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        monthHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).inset(-26)
            make.centerX.equalToSuperview()
        }
        previousMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthHeaderLabel.snp.centerY)
            make.leading.equalToSuperview().inset(22)
            make.size.equalTo(30)
        }
        nextMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthHeaderLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(22)
            make.size.equalTo(30)
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(monthHeaderLabel.snp.bottom).inset(-30)
            make.leading.trailing.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func bind() {
        previousMonthButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let currentMonth = self.calendar.currentPage
                guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) else { return }
                self.calendar.setCurrentPage(previousMonth, animated: true)
            }.disposed(by: disposeBag)
        
        nextMonthButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let currentMonth = self.calendar.currentPage
                guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) else { return }
                self.calendar.setCurrentPage(nextMonth, animated: true)
            }.disposed(by: disposeBag)
    }
}
