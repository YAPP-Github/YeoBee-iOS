//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by 이호영 on
//

import UIKit
import ReactorKit
import Coordinator
import DesignSystem
import SnapKit
import RxCocoa

public final class OnboardingViewController: UIViewController, View {
    public var disposeBag = DisposeBag()
    public var coordinator: OnboardingCoordinator?
    private var pageViewController: UIPageViewController!
    private var pages: [UIViewController] = []
    private var currentPageIndex = 0
    
    private let nextButton = YBTextButton(text: "", appearance: .default, size: .large)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupNextButton()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if self.currentPageIndex < self.pages.count - 1 {
                self.goToNextPage()
            } else {
                self.goHome()
            }
        }.disposed(by: disposeBag)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPageViewController() {
        let page1 = UIViewController() // 첫 번째 페이지 뷰 컨트롤러 초기화
        let page2 = UIViewController() // 두 번째 페이지 뷰 컨트롤러 초기화
        let page3 = UIViewController() // 세 번째 페이지 뷰 컨트롤러 초기화
        pages = [page1, page2, page3]
        page1.view.backgroundColor = .blue
        page2.view.backgroundColor = .red
        page3.view.backgroundColor = .yellow
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.frame = self.view.bounds
    }
    
    private func setupNextButton() {
        nextButton.setTitle("다음으로", for: .normal)
        nextButton.backgroundColor = .clear
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalTo(view)
            make.width.equalToSuperview().offset(-24)
        }
        nextButton.rx.tap.bind { [weak self] in
            self?.goToNextPage()
        }.disposed(by: disposeBag)
    }
    
    private func goToNextPage() {
          currentPageIndex += 1
          if currentPageIndex < pages.count {
              let nextViewController = pages[currentPageIndex]
              pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
          }
          if currentPageIndex == pages.count {
              nextButton.setTitle("시작하기", for: .normal)
          }
      }
    
    private func goHome() {
        coordinator?.home()
    }
    
    public func bind(reactor: OnboardingReactor) {
        //Action
        
        //State
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex > 0 else { return nil }
        return pages[viewControllerIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex < pages.count - 1 else { return nil }
        return pages[viewControllerIndex + 1]
    }
}
