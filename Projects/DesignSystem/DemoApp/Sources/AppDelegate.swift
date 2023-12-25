import UIKit
import DesignSystem

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window?.backgroundColor = .white
        print(UIScreen.main.bounds)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let viewController = DesignSystemViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
       
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}
