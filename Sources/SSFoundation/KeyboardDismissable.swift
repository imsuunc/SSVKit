import UIKit
import ObjectiveC.runtime

public protocol KeyboardDismissable { }

private var KDAssociatedGestureDelegateKey: UInt8 = 0

private class KDGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView is UIControl {
            return false
        }
        if let touchedView = touch.view, touchedView is UITextView {
            return false
        }
        return true
    }
}

extension UIViewController {

    public static let shouldResignOnTouchOutside: Void = {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.kd_viewDidLoad)
        guard
            let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    @objc private func kd_viewDidLoad() {
        self.kd_viewDidLoad()
        if self is KeyboardDismissable {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditingBackgroundTapped))
            tapGestureRecognizer.cancelsTouchesInView = false
            let delegate = KDGestureDelegate(viewController: self)
            tapGestureRecognizer.delegate = delegate
            objc_setAssociatedObject(self, &KDAssociatedGestureDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            view.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    @objc private func endEditingBackgroundTapped() {
        view.endEditing(true)
    }
    
}

extension UIViewController {
    
    public static let shouldResignOnNavigation: Void = {
        let originalPresent = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.present(_:animated:completion:)))
        let swizzledPresent = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.kd_present(_:animated:completion:)))
        if let originalPresent = originalPresent, let swizzledPresent = swizzledPresent {
            method_exchangeImplementations(originalPresent, swizzledPresent)
        }
        let originalPush = class_getInstanceMethod(UINavigationController.self, #selector(UINavigationController.pushViewController(_:animated:)))
        let swizzledPush = class_getInstanceMethod(UINavigationController.self, #selector(UINavigationController.kd_pushViewController(_:animated:)))
        if let originalPush = originalPush, let swizzledPush = swizzledPush {
            method_exchangeImplementations(originalPush, swizzledPush)
        }
    }()
    
    @objc private func kd_present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.view.endEditing(true)
        self.kd_present(viewControllerToPresent, animated: animated, completion: completion)
    }
    
}

private extension UINavigationController {
    
    @objc func kd_pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.view.endEditing(true)
        self.kd_pushViewController(viewController, animated: animated)
    }
    
}
