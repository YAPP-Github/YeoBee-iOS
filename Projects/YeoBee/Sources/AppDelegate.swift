import UIKit
import Expenditure

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let coordinator = RootCoordinator(navigationController: navigationController)
        coordinator.start(animated: false)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}
