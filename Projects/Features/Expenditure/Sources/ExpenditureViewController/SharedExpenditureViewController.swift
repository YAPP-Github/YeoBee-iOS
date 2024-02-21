//
//  SharedExpenditure.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture
import Entity

public final class SharedExpenditureViewController: UIViewController {

    let coordinator: ExpenditureCoordinator
    let store: StoreOf<SharedExpenditureReducer>
    let tripItem: TripItem

    // MARK: View

    private let sharedExpenditureHostingController: SharedExpenditureHostingController

    public init(coordinator: ExpenditureCoordinator, tripItem: TripItem) {
        self.coordinator = coordinator
        self.tripItem = tripItem
        let store: StoreOf<SharedExpenditureReducer> = .init(
            initialState: .init(tripItem: tripItem),
            reducer: {
                SharedExpenditureReducer(cooridinator: coordinator)
            })
        self.store = store
        self.sharedExpenditureHostingController = SharedExpenditureHostingController(
            rootView: SharedExpenditureView(store: store)
        )
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setLayouts()
        setNavigationBar()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        title = tripItem.title
        navigationController?.tabBarItem.title = "가계부"
        navigationController?.tabBarItem.image = DesignSystemAsset.Icons.accountBook.image
        navigationController?.toolbar.barTintColor = YBColor.black.color
        view.backgroundColor = .ybColor(.gray1)
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.delete.image
            .withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        let setImage = DesignSystemAsset.Icons.set.image
            .withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let setButton = UIBarButtonItem(image: setImage, style: .plain, target: self, action: #selector(setButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = setButton
    }

    @objc func backButtonTapped() {
        coordinator.coordinatorDidFinish()
    }

    @objc func setButtonTapped() {
        coordinator.tripSetting()
    }

    public func setRefreshData() {
        store.send(.individualExpenditure(.refresh))
        store.send(.sharedExpenditure(.refresh))
    }

    public func getExpenseList(editDate: Date) {
        store.send(.individualExpenditure(.getExpenseList(editDate)))
        store.send(.sharedExpenditure(.getExpenseList(editDate)))
    }

    func setLayouts() {
        view.addSubview(sharedExpenditureHostingController.view)

        sharedExpenditureHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

