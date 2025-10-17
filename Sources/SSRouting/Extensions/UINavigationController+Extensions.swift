import UIKit

public extension UINavigationController {
    
    func open(viewController: UIViewController, from subtype: CATransitionSubtype = .fromTop) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = subtype
        view.layer.add(transition, forKey: kCATransition)
        pushViewController(viewController, animated: false)
    }
    
    func close(to subtype: CATransitionSubtype = .fromBottom) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = subtype
        view.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
}
