import UIKit
#if canImport(SSFoundation)
@_exported import SSFoundation
#endif

open class SViewController: UIViewController {
    
    open var tabBarItemView: STabBarItemView? = nil
    open var isNavigationBarHiden: Bool = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initializeNotification()
        initializeViews()
        initializeData()
    }
    
    @objc open func initializeNotification() {
        preconditionFailure("This method must be overridden")
    }
    
    @objc open func initializeViews() {
        preconditionFailure("This method must be overridden")
    }
    
    @objc open func initializeData() {
        preconditionFailure("This method must be overridden")
    }
    
}

extension SViewController {
    
    @objc open var backgroundColor: UIColor? {
        get {
            return view.backgroundColor
        }
        set {
            view.backgroundColor = newValue
        }
    }
    
    @objc open func addSubview(_ subview: UIView) {
        view.addSubview(subview)
    }
    
}
