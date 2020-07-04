import UIKit

protocol CoordinatorProtocol: AnyObject {
    /// Array of children of current coordinator
    var childCoordinators: [BaseCoordinator] { get }

    /// Parent coordinator of current. Should be always present (exception of AppCoordinator).
    /// May serve as delegate for its children
    var parentCoordinator: CoordinatorProtocol? { get }

    var rootViewController: UIViewController { get set }

    /// Start current coordinator, code to init viewController should go there
    func start()

    /// Close child coordinator and remove it from children array
    func stop(chilCoordinator: BaseCoordinator)

    /// Reset coordinator state
    func reset()
}

/// Base coordinator class, shouldn't be initialized directly

class BaseCoordinator: NSObject, CoordinatorProtocol {
    typealias Dependencies = AppDependency

    var dependencies: Dependencies?

    var childCoordinators: [BaseCoordinator] = []

    var parentCoordinator: CoordinatorProtocol?

    var rootViewController: UIViewController

    init(withViewController viewController: UIViewController,
         dependencies: Dependencies?,
         andParentCoordinator parentCoordinator: CoordinatorProtocol? = nil) {
        rootViewController = viewController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }

    func start() {}

    func stop(chilCoordinator _: BaseCoordinator) {}

    func reset() {}
}
