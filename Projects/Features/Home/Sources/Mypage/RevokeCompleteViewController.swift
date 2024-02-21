//
//  RevokeCompleteViewController.swift
//  Home
//
//  Created by 김태형 on 2/22/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import ReactorKit
import SnapKit

final class RevokeCompleteViewController: UIViewController, View {
    public var disposeBag: DisposeBag = DisposeBag()
    private let reactor = RevokeCompleteReactor()
    public var coordinator: RevokeCompleteCoordinator?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.Icons.cryingBee.image
        return imageView
    }()
    let titleLabel = YBLabel(text: "탈퇴가 완료되었어요.", font: .header2)
    let descriptionLabel = YBLabel(font: .body3)
    
    let confirmButton = YBTextButton(text: "홈으로 돌아가기", appearance: .default, size: .large)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBar()
        setupViews()
        setLayouts()
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "회원탈퇴"
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func bind(reactor: RevokeCompleteReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: RevokeCompleteReactor) {
        confirmButton.rx.tap
            .subscribe(onNext: {
                self.coordinator?.login()
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: RevokeCompleteReactor) {
        
    }
    
    func setupViews() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "그동안 여비를 이용해주셔서 감사드려요.\n다시 찾아주실 때에는 더욱 만족하실 수 있도록 노력할게요.\n더 나은 서비스로 다시 만나길 바라요!"
    }
    
    func setLayouts() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(confirmButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(153)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(142)
            make.height.equalTo(107)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-38)
        }
    }
}
