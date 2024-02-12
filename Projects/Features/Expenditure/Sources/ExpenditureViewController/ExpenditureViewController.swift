//
//  ExpenditureListViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture
import Coordinator

public final class ExpenditureViewController: UIViewController {

    let coordinator: ExpenditureCoordinator
    let store: StoreOf<ExpenditureReducer>

    // MARK: View

    private let expenditureHostingController: ExpenditureHostingController

//    // MARK: DataSources

    public init(coordinator: ExpenditureCoordinator) {
        self.coordinator = coordinator

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        let store: StoreOf<ExpenditureReducer> = .init(
            initialState: .init(type: .individual, tripId: 1, startDate: startDate, endDate: endDate),
            reducer: {
                ExpenditureReducer(cooridinator: coordinator)
            })
        self.store = store
        self.expenditureHostingController = ExpenditureHostingController(
            rootView: ExpenditureView(
                store: store
            )
        )
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setupViews()
        setLayouts()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        title = "일본 여행" // trip name
        navigationController?.tabBarItem.title = "가계부"
        navigationController?.tabBarItem.image = DesignSystemAsset.Icons.accountBook.image
        navigationController?.toolbar.barTintColor = YBColor.black.color
        view.backgroundColor = .ybColor(.gray1)
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.home.image
            .withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        coordinator.coordinatorDidFinish()
    }

    func setLayouts() {
        view.addSubview(expenditureHostingController.view)

        expenditureHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    public func getExpenseList(editDate: Date) {
        store.send(.getExpenseList(editDate))
    }

    deinit {
        print("ExpenditureViewController is de-initialized.")
    }
}
