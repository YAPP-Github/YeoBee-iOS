//
//  BottomSheetPresentationController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/24.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

public class BottomSheetViewController: DesignSystemBaseViewController {
    
    public let button: UIButton = {
        let button = UIButton()
        button.setTitle("bottomSheet", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    public let toastButton: UIButton = {
        let button = UIButton()
        button.setTitle("toast", for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toastButtonTapped), for: .touchUpInside)
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "TextField"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public override func setupView() {
        super.setupView()
        
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(toastButton)
    }

    @objc
    func buttonTapped() {
        let vc = TestBottomSheetViewController()
        presentBottomSheet(presentedViewController: vc, height: 300)
    }

    @objc
    func toastButtonTapped() {
        let toast = Toast.text(icon: .complete, "최대 10명까지 추가할 수 있어요.")
        toast.show()
    }
}
