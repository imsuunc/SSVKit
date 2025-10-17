import UIKit

public protocol SRoute {
    
    var screen: UIViewController { get }
    
}

public enum SRouterTransitionFrom: Equatable {
    case right
    case left
    case top
    case bottom
}

public enum SRouterTransitionStyle: Equatable {
    case formSheet
    case pageSheet
    case fullScreen
    case overFullScreen
    case currentContext
    case overCurrentContext
    case popover
}

public enum SRouterTransition: Equatable {
    case present(_ from: SRouterTransitionFrom = .bottom, _ style: SRouterTransitionStyle = .fullScreen)
    case open(_ from: SRouterTransitionFrom)
    case push
    case root
    case reset
}

@MainActor 
public protocol SRouter: AnyObject {
    
    var rootViewController: UINavigationController? { get set }
    
    var currentViewController: UIViewController? { get set }
    
    var arrayTransitions: [SRouterTransition] { get set }
    
    init(with route: SRoute)
    
    func navigate(to route: SRoute, with transition: SRouterTransition,
                  animated: Bool, completion: (() -> Void)?)
    
    func navigate(to router: SRouter, animated: Bool, completion: (() -> Void)?)
    
    func exit(_ animated: Bool,_ completion: (() -> Void)?)
    
    func pop(to index: Int, animated: Bool)
    
}

@MainActor
public extension SRouter {
    
    func navigate(to route: SRoute, with transition: SRouterTransition, animated: Bool = true, completion: (() -> Void)? = nil) {
        let lastTransition = arrayTransitions.last
        arrayTransitions.append(transition)
        let viewController = route.screen
        switch transition {
        case let .present(from, style):
            switch from {
            case .right:
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.moveIn
                transition.subtype = CATransitionSubtype.fromRight
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.isRemovedOnCompletion = true
                currentViewController?.view.window?.layer.add(transition, forKey: kCATransition)
            case .left:
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.moveIn
                transition.subtype = CATransitionSubtype.fromLeft
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.isRemovedOnCompletion = true
                currentViewController?.view.window?.layer.add(transition, forKey: kCATransition)
            case .top:
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromBottom
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.isRemovedOnCompletion = true
                currentViewController?.view.window?.layer.add(transition, forKey: kCATransition)
            case .bottom:
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.moveIn
                transition.subtype = CATransitionSubtype.fromTop
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.isRemovedOnCompletion = true
                currentViewController?.view.window?.layer.add(transition, forKey: kCATransition)
            }
            switch style {
            case .formSheet:
                viewController.modalPresentationStyle = UIModalPresentationStyle.formSheet
            case .pageSheet:
                viewController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            case .fullScreen:
                viewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            case .overFullScreen:
                viewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            case .currentContext:
                viewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
            case .overCurrentContext:
                viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            case .popover:
                viewController.modalPresentationStyle = UIModalPresentationStyle.popover
            }
            currentViewController?.present(viewController, animated: animated, completion: completion)
            currentViewController = viewController
        case .push:
            if let lastTransition = lastTransition, lastTransition == .present() {
                rootViewController?.dismiss(animated: animated) { [weak self] in
                    self?.rootViewController?.pushViewController(viewController, animated: animated)
                    self?.currentViewController = viewController
                }
            } else {
                rootViewController?.pushViewController(viewController, animated: animated)
                currentViewController = viewController
            }
        case .reset:
            arrayTransitions.removeAll()
            rootViewController?.setViewControllers([viewController], animated: animated)
            currentViewController = viewController
        case .root:
            arrayTransitions.removeAll()
            let navigationController = UINavigationController(rootViewController: viewController)
            UIApplication.window?.rootViewController = navigationController
            rootViewController = navigationController
            rootViewController?.isNavigationBarHidden = true
            UIApplication.window?.makeKeyAndVisible()
            currentViewController = viewController
            navigationController.view.alpha = 0
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                navigationController.view.alpha = 1.0
            })
        case let .open(from):
            switch from {
            case .right:
                rootViewController?.open(viewController: viewController, from: .fromRight)
            case .left:
                rootViewController?.open(viewController: viewController, from: .fromLeft)
            case .top:
                rootViewController?.open(viewController: viewController, from: .fromTop)
            case .bottom:
                rootViewController?.open(viewController: viewController, from: .fromBottom)
            }
            currentViewController = viewController
        }
    }
    
    func navigate(to router: SRouter, animated: Bool, completion: (() -> Void)?) {
        guard let viewController = router.rootViewController else {
            assert(false, "Router does not have a root view controller")
            return
        }
        currentViewController?.present(viewController, animated: animated, completion: completion)
        currentViewController = viewController
    }
    
}

@MainActor
extension SRouter {
    
    public func exit(_ animated: Bool = true,_ completion: (() -> Void)? = nil) {
        if let transition = arrayTransitions.last {
            switch transition {
            case .present:
                arrayTransitions.removeLast()
                dismiss(animated, completion)
                break
            case .open(let from):
                arrayTransitions.removeLast()
                switch from {
                case .right:
                    rootViewController?.close(to: .fromLeft)
                case .left:
                    rootViewController?.close(to: .fromRight)
                case .top:
                    rootViewController?.close(to: .fromBottom)
                case .bottom:
                    rootViewController?.close(to: .fromTop)
                }
                currentViewController = rootViewController?.topViewController
                completion?()
                break
            case .push:
                arrayTransitions.removeLast()
                pop(animated)
                completion?()
                break
            case .root:
                arrayTransitions.removeAll()
                break
            case .reset:
                arrayTransitions.removeAll()
                break
            }
        }
    }
    
    public func pop(to index: Int = 0, animated: Bool = true) {
        if index < 0 {
            rootViewController?.popToRootViewController(animated: animated)
            return
        }
        guard
            let viewControllers = rootViewController?.viewControllers,
            viewControllers.count > index
            else { return }
        let viewController = viewControllers[index]
        rootViewController?.popToViewController(viewController, animated: animated)
        currentViewController = viewController
    }
    
}

@MainActor
extension SRouter {
    
    private func pop(_ animated: Bool = true) {
        guard
            let viewControllers = rootViewController?.viewControllers,
            !viewControllers.isEmpty
            else { return }
        rootViewController?.popViewController(animated: animated)
        currentViewController = rootViewController?.topViewController
    }
    
    private func dismiss(_ animated: Bool = true,_ completion: (() -> Void)? = nil) {
        let presentingViewController = currentViewController?.presentingViewController
        currentViewController?.dismiss(animated: animated, completion: completion)
        currentViewController = presentingViewController
    }
    
    private func close(_ animated: Bool = true,_ completion: (() -> Void)? = nil) {
        rootViewController?.dismiss(animated: animated, completion: completion)
        currentViewController = rootViewController?.topViewController
    }
    
}
