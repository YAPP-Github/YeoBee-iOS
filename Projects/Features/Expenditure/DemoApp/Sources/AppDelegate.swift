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
        let reactor = ExpenditureListReactor(totalPriceReactorFactory: TotalPriceReactor.init)
        let viewController = ExpenditureListViewController()
        viewController.reactor = reactor
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}
