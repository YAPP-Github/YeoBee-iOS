//
//  ExpenditureEditViewController.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee 
//

import UIKit
import DesignSystem
import SnapKit
import ComposableArchitecture

public final class ExpenditureEditViewController: UIViewController {

    // MARK: View

    private let expenditureHostingController = ExpenditureHostingController(
        rootView: ExpenditureView(
            store: .init(
                initialState: .init(seletedExpenditureType: .shared),
                reducer: {
                    ExpenditureReducer()
                }
            )
        )
    )

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
        view.addSubview(expenditureHostingController.view)

        expenditureHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
}