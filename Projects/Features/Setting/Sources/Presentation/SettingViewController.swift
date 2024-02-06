//
//  SettingViewController.swift
//  Setting
//
//  Created by 박현준 
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import SnapKit
import RxSwift
import RxCocoa

public final class SettingViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: SettingReactor
    private let coordinator: SettingCoordinator
    
    // MARK: - Properties
    
    
    // MARK: - Life Cycles
    public init(coordinator: SettingCoordinator ,reactor: SettingReactor) {
        self.coordinator = coordinator
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        addViews()
        setLayouts()
        configureBar()
        bind(reactor: reactor)
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
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("deinit SettingViewController")
    }
}

// MARK: - Bind
extension SettingViewController: View {
    public func bind(reactor: SettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingReactor) {
        
    }
    
    func bindState(reactor: SettingReactor) {
        
    }
}
