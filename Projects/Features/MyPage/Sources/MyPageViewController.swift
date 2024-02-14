//
//  MyPageViewController.swift
//  Trip
//
//  Created by Hoyoung Lee 
//

import UIKit
import ReactorKit

public class MyPageViewController: UIViewController, View {

    public var disposeBag = DisposeBag()
    public var coordinator: MyPageCoordinator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("👋 hello Mypage Scene")
    }
    
    public func bind(reactor: MyPageReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindAction(reactor: MyPageReactor) {
        
    }
    
    func bindState(reactor: MyPageReactor) {
        
    }
}
