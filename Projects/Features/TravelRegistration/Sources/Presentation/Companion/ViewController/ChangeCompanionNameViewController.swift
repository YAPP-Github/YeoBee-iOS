//
//  ChangeCompanionNameViewController.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import RxSwift
import RxCocoa

public final class ChangeCompanionNameViewController: TravelRegistrationController {
    
    public var disposeBag = DisposeBag()
    private let reactor: ChangeCompanionNameReactor
    // MARK: - Properties
    
    
    // MARK: - Life Cycles
    init(reactor: ChangeCompanionNameReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setLayouts()
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            
        ].forEach {
            view.addSubview($0)
        }
        
    }
    
    private func setLayouts() {
        
    }
}
