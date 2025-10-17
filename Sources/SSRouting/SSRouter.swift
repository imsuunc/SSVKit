import UIKit

open class SSRouter: NSObject, SRouter {
    
    public var rootViewController: UINavigationController?
    public var currentViewController: UIViewController?
    public var arrayTransitions: [SRouterTransition] = []
    
    public required init(with route: SRoute) {
        let viewController = route.screen
        rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController?.isNavigationBarHidden = true
        currentViewController = viewController
    }
    
}

