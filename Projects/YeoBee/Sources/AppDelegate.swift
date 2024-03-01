import UIKit
import Expenditure
import ComposableArchitecture
import UseCase
import Repository
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        let appkey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String ?? ""
        KakaoSDK.initSDK(appKey: appkey)


        FirebaseApp.configure()

        Analytics.setConsent([
          .analyticsStorage: .granted,
          .adStorage: .granted
        ])

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }
}
