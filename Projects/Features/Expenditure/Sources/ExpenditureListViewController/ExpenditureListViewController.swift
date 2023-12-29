//
//  ExpenditureListViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//


import UIKit
import ReactorKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture

public final class ExpenditureListViewController: UIViewController, View {

    public var disposeBag: DisposeBag = DisposeBag()

    // MARK: View

    private let expenditureListHostingController = ExpenditureListHostingController(
        rootView: ExpenditureListView(
            store: .init(
                initialState: .init(),
                reducer: {
                    ExpenditureListReducer()
                }
            )
        )
    )

//    // MARK: DataSources
//
//    private let tripDateDataSource: TripDateDataSource

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setLayouts()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public func bind(reactor: ExpenditureListReactor) {
    }

    func setupViews() {
        title = "일본 여행"
    }

    func setLayouts() {
        view.addSubview(expenditureListHostingController.view)

        expenditureListHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
