import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start(animated: Bool)
    func popViewController(animated: Bool)
}

public extension Coordinator {

    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    func popToViewController(to viewController: UIViewController, animated: Bool = true) {
        navigationController.popToViewController(viewController, animated: animated)
    }
}

public protocol ParentCoordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func addChild(_ child: Coordinator?)
    func childDidFinish(_ child: Coordinator?)
}

public extension ParentCoordinator {
    func addChild(_ child: Coordinator?) {
        if let _child = child {
            childCoordinators.append(_child)
        }
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

public protocol ChildCoordinator: Coordinator {
    func coordinatorDidFinish()
    var viewControllerRef: UIViewController? { get set }
}
