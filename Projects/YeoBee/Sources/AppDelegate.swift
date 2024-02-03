import UIKit
import Expenditure
import ComposableArchitecture
import UseCase
import Repository

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

        withDependencies { dependencyValue in
            let repository = ExpenseRepository()
            dependencyValue.expenseUseCase = .live(expenseRepository: repository)
        } operation: {

        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
