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
        let coordinator = ExpenditureCoordinator(navigationController: UINavigationController())
        coordinator.start(animated: false)
        window?.rootViewController = coordinator.expenditureNavigationController
        window?.makeKeyAndVisible()

        return true
    }

}
