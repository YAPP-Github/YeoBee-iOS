//
//  ExpenditureEditViewController.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import ComposableArchitecture
import Entity

public final class ExpenditureUpdateViewController: UIViewController {

    let coordinator: ExpenditureEditCoordinator
    let editDate: Date = Date()

    // MARK: View

    private let expenditureHostingController: ExpenditureUpdateHostingController

    public init(
        coordinator: ExpenditureEditCoordinator,
        tripItem: TripItem,
        expenseDetail: ExpenseDetailItem,
        expenditureTab: ExpenditureTab
    ) {
        self.coordinator = coordinator
        self.expenditureHostingController = ExpenditureUpdateHostingController(
            rootView: ExpenditureUpdateView(
                store: .init(
                    initialState: .init(expenditureTab: .individual, tripItem: tripItem, expenseDetail: expenseDetail),
                    reducer: {
                        ExpenditureUpdateReducer(cooridinator: coordinator)
                    }
                )
            )
        )
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setLayouts()
        setNavigationBar()
        hideKeyboardWhenTappedAround()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        title = editDateFormatter.string(from: editDate)
        view.backgroundColor = .ybColor(.gray1)
    }

    func setLayouts() {
        view.addSubview(expenditureHostingController.view)

        expenditureHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.delete.image
            .withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        coordinator.coordinatorDidFinish()
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        navigationController?.view.endEditing(true)
    }

    var editDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM.dd(EE)"
        return dateFormatter
    }

    deinit {
        print("ExpenditureEditViewController deinit")
    }
}
