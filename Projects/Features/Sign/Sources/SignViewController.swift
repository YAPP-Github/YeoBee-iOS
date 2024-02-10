//
//  SignViewController.swift
//  SignDemoApp
//
//  Created by 이호영
//

import UIKit
import Coordinator
import ReactorKit
import RxSwift
import RxCocoa
import Coordinator
import DesignSystem
import SnapKit
import YBNetwork

public final class SignViewController: UIViewController, View {
    public var coordinator: SignCoordinator?
    public var disposeBag: DisposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    let logoImageView = UIImageView()
    let illustImageView = UIImageView()
    let kakaoLoginButton = YBIconWithTextButton(text: "카카오로 시작하기", appearance: .kakao)
    let appleLoginButton = YBIconWithTextButton(text: "Apple로 시작하기", appearance: .apple)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setLayouts()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(reactor: SignReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SignReactor) {
        kakaoLoginButton.rx.tap
            .map{ .kakao }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .map{ SignReactor.Action.apple}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindState(reactor: SignReactor) {
        reactor.state.map { $0.isLoginSuccess }
            .subscribe(onNext : { [weak self] isSuccess in
                if isSuccess {
                    self?.coordinator?.createAccount()
                } else {
                    //오류 Alert
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupViews() {
        titleLabel.text = "모두를 위한 여행 정산 가계부"
        titleLabel.font = .ybfont(.title1)
        view.backgroundColor = YBColor.white.color
        illustImageView.image = DesignSystemAsset.Icons.illust.image
        logoImageView.image = DesignSystemAsset.Icons.logo.image
    }
    
    private func setLayouts() {
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        view.addSubview(illustImageView)
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(146)
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        illustImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(89)
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-49)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(illustImageView.snp.bottom).offset(67)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).offset(-48)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).offset(-48)
        }
    }
}
