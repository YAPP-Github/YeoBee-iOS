//
//  SignViewController.swift
//  SignDemoApp
//
//  Created by 이호영
//

import UIKit
import SnapKit
import Coordinator

public class SignViewController: UIViewController {

    public weak var coordinator: SignCoordinatorInterface?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
