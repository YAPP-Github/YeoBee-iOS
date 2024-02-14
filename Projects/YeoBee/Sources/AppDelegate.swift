import UIKit
import Expenditure
import ComposableArchitecture
import UseCase
import Repository
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // 런치 스크린
        Thread.sleep(forTimeInterval: 1.5)
        
        let navigationController = UINavigationController()
        let tokenRepository = TokenRepository.shared

        navigationController.hidesBottomBarWhenPushed = true
        
        Task {
            let isTokenExpiring = try await tokenRepository.isTokenExpiring()
            let isOnboardingCompleted = try await UserInfoRepository().isOnboardingCompleted()
            
            DispatchQueue.main.async {
                let coordinator = RootCoordinator(
                    navigationController: navigationController,
                    isTokenExpring: isTokenExpiring,
                    isOnboardingCompleted: isOnboardingCompleted
                )
                coordinator.start(animated: false)
                
                self.window?.overrideUserInterfaceStyle = .light
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
        
        let appkey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String ?? ""
        KakaoSDK.initSDK(appKey: appkey)
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
