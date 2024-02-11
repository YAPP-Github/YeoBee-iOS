//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by 이호영 on 
//

import UIKit
import ReactorKit

public final class OnboardingViewController: UIViewController, View {
    public var disposeBag: DisposeBag = DisposeBag()
    public weak var coordinator: OnboardingCoordinator?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(reactor: OnboardingReactor) {
        //Action
        
        //State
    }
}
