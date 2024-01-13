//
//  TravelRegistrationController.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/31/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem

import Coordinator

public class TravelRegistrationController: UIViewController {

    public weak var coordinator: TravelRegistrationCoordinator?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        configureBar()
    }
    
    private func setView() {
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        navigationController?.view.endEditing(true)
    }
    
    func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        coordinator?.coordinatorDidFinish()
    }

    deinit {
        print("TravelRegistrationController is de-initialized.")
    }
}
