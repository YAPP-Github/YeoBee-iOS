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

public final class SharedExpenditureViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()

    // MARK: View

    private let sharedExpenditureHostingController = SharedExpenditureHostingController(
        rootView: SharedExpenditureView(
            store: .init(
                initialState: .init(),
                reducer: {
                    SharedExpenditureReducer()
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

    func setupViews() {
        title = "일본 여행"
        view.backgroundColor = .ybColor(.gray1)
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

