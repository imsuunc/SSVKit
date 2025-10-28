import UIKit
#if canImport(SSFoundation)
@_exported import SSFoundation
#endif

open class STabBarController: SViewController {
    
    private var currentViewController: SViewController?
    private var currentNavigationController: UINavigationController?
    private var constraintViewCustomHeight: NSLayoutConstraint?
    private var constraintViewTabBarHeight: NSLayoutConstraint?
    private var constraintViewShadowHeight: NSLayoutConstraint?
    private var constraintViewControllerBottom: NSLayoutConstraint?
    private var constraintViewControllerPosition: NSLayoutConstraint?
    // MARK: NAVIGATIONS
    private var navigationControllers = [UINavigationController]()
    // MARK: Container
    private var viewContainerController: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewShadow: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }()
    
    private var viewTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }()
    
    private var viewCustom: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }()
    
    // MARK: MUST SET BEFORE SETUP
    open var isUsingSafeArea: Bool = false
    
    open var viewShadowOpacity: Float = 0.15 {
        didSet {
            if viewShadowOpacity != oldValue {
                viewShadow.layer.shadowOpacity = viewShadowOpacity
            }
        }
    }
    
    open var viewShadowRadius: CGFloat = 1 {
        didSet {
            if viewShadowRadius != oldValue {
                viewShadow.layer.shadowRadius = viewShadowRadius
            }
        }
    }
    
    open var viewShadowOffset: CGSize = CGSize(width: 0, height: -1) {
        didSet {
            if viewShadowOffset != oldValue {
                viewShadow.layer.shadowOffset = viewShadowOffset
            }
        }
    }
    
    open var viewShadowColor: UIColor = .clear {
        didSet {
            if viewShadowColor != oldValue {
                viewShadow.backgroundColor = viewShadowColor.withAlphaComponent(0.15)
                viewShadow.layer.shadowColor = viewShadowColor.cgColor
                viewShadow.layer.masksToBounds = false
            }
            if viewShadowColor == .clear {
                constraintViewShadowHeight?.constant = 0
            }
        }
    }
    
    open var viewShadowHeight: CGFloat = 1 {
        didSet {
            if let constraintViewShadowHeight = constraintViewShadowHeight, viewShadowHeight != oldValue {
                constraintViewShadowHeight.constant = viewShadowHeight
            }
        }
    }
    
    open var isShowViewShadow: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.constraintViewShadowHeight?.constant = self.isShowViewShadow ? self.viewShadowHeight : 0
                self.viewShadow.isHidden = !self.isShowViewShadow
                self.setNeedsFocusUpdate()
            }
        }
    }
    
    open var viewTabBarColor: UIColor = .clear {
        didSet {
            viewTabBar.backgroundColor = viewTabBarColor
        }
    }
    
    open var viewTabBarHeight: CGFloat = 56 {
        didSet {
            if let constraintViewTabBarHeight = constraintViewTabBarHeight, viewTabBarHeight != oldValue {
                constraintViewTabBarHeight.constant = viewTabBarHeight
            }
        }
    }
    
    open var viewCustomColor: UIColor = .clear {
        didSet {
            viewCustom.backgroundColor = viewCustomColor
        }
    }
    
    open var viewCustomHeight: CGFloat = 50 {
        didSet {
            if let constraintViewCustomHeight = constraintViewCustomHeight, viewCustomHeight != oldValue {
                constraintViewCustomHeight.constant = viewCustomHeight
            }
        }
    }
    
    open var isShowViewCustom: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.constraintViewCustomHeight?.constant = self.isShowViewCustom ? self.viewCustomHeight : 0
                self.viewCustom.isHidden = !self.isShowViewCustom
                self.setNeedsFocusUpdate()
            }
        }
    }
    
    open var viewContollers = [SViewController]() {
        didSet {
            initializeViewControllers()
        }
    }
    
    open var selectedIndex: Int = -1 {
        didSet {
            if selectedIndex < 0 || selectedIndex > viewContollers.count {
                fatalError("ViewControllers: Index out of bounds.")
            }
            if selectedIndex != oldValue {
                if viewContollers.count > 0 && viewContollers.count > oldValue  {
                    if oldValue >= 0 {
                        viewContollers[oldValue].tabBarItemView?.isSelected = false
                    }
                    didSelected(index: selectedIndex, viewController: viewContollers[selectedIndex])
                    loadViewControllers()
                }
            }
            if viewContollers.count > 0 && viewContollers.count > selectedIndex  {
                viewContollers[selectedIndex].tabBarItemView?.isSelected = true
            }
        }
    }
    
    open override func initializeNotification() {
        
    }
    
    open override func initializeViews() {
        initializeTabBarItems()
    }
    
    open override func initializeData() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension STabBarController {
    
    private func initializeTabBarItems() {
        view.addSubview(viewContainerController)
        view.addSubview(viewCustom)
        view.addSubview(viewTabBar)
        view.addSubview(viewShadow)
        viewCustom.backgroundColor = viewCustomColor
        viewCustom.leadingToSuperview(usingSafeArea: isUsingSafeArea)
        viewCustom.trailingToSuperview(usingSafeArea: isUsingSafeArea)
        viewCustom.bottomToSuperview(usingSafeArea: true)
        viewCustom.isHidden = !isShowViewCustom
        constraintViewCustomHeight = viewCustom.height(isShowViewCustom ? viewCustomHeight : 0)
        
        viewTabBar.leadingToSuperview(usingSafeArea: isUsingSafeArea)
        viewTabBar.trailingToSuperview(usingSafeArea: isUsingSafeArea)
        viewTabBar.bottomToTop(of: viewCustom)
        constraintViewTabBarHeight = viewTabBar.height(viewTabBarHeight)
        
        viewShadow.leadingToSuperview(usingSafeArea: isUsingSafeArea)
        viewShadow.trailingToSuperview(usingSafeArea: isUsingSafeArea)
        viewShadow.bottomToTop(of: viewTabBar)
        constraintViewShadowHeight = viewShadow.height(isShowViewShadow ? viewShadowHeight : 0)
        
        viewContainerController.leadingToSuperview(usingSafeArea: isUsingSafeArea)
        viewContainerController.trailingToSuperview(usingSafeArea: isUsingSafeArea)
        viewContainerController.topToSuperview(usingSafeArea: isUsingSafeArea)
        constraintViewControllerPosition = viewContainerController.bottomToSuperview(priority: .defaultLow, usingSafeArea: isUsingSafeArea)
        constraintViewControllerPosition?.isActive = false
        constraintViewControllerBottom = viewContainerController.bottomToTop(of: viewShadow)
        constraintViewControllerBottom?.isActive = true
        
    }
    
    private func initializeViewControllers() {
        var tabBarItems: [STabBarItemView] = []
        for (index, controller) in viewContollers.enumerated() {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.delegate = self
            navigationController.isNavigationBarHidden = controller.isNavigationBarHiden
            navigationControllers.append(navigationController)
            if let barItem = controller.tabBarItemView {
                tabBarItems.append(barItem)
                barItem.isSelected = false
                barItem.onTouch = {
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        self.selectedIndex = index
                        self.didSelected(index: self.selectedIndex, viewController: controller)
                    }
                }
            } else {
                var image: UIImage?
                if #available(iOS 13.0, *) {
                    image = UIImage(systemName: "\(index + 1).circle")
                }
                let barItem = STabBarItemView(title: "Item \(index + 1)", icon: image)
                controller.tabBarItemView = barItem
                tabBarItems.append(barItem)
                barItem.isSelected = false
                barItem.onTouch = {
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        self.selectedIndex = index
                        self.didSelected(index: self.selectedIndex, viewController: controller)
                    }
                }
            }
        }
        viewTabBar.stack(tabBarItems, axis: .horizontal, spacing: 0)
        selectedIndex = 0
        didSelected(index: selectedIndex, viewController: viewContollers[0])
    }
    
    private func loadViewControllers() {
        let selectedViewController: UINavigationController = navigationControllers[selectedIndex]
        addChild(selectedViewController)
        selectedViewController.view.frame = viewContainerController.bounds
        viewContainerController.addSubview(selectedViewController.view)
        selectedViewController.didMove(toParent: self)
        currentNavigationController?.remove()
        currentNavigationController = selectedViewController
    }
    
}

extension STabBarController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController != navigationController.viewControllers.first {
            UIView.animate(withDuration: 0.15) {
                self.viewTabBar.isHidden = true
                self.constraintViewTabBarHeight?.constant = 0
                if self.isUsingSafeArea {
                    self.constraintViewControllerPosition?.isActive = false
                    self.constraintViewControllerBottom?.isActive = true
                } else {
                    self.constraintViewControllerPosition?.isActive = true
                    self.constraintViewControllerBottom?.isActive = false
                }
                self.view.layoutIfNeeded()
            }
        } else {
            constraintViewControllerPosition?.isActive = false
            constraintViewControllerBottom?.isActive = true
            constraintViewTabBarHeight?.constant = viewTabBarHeight
            viewTabBar.isHidden = false
            view.layoutIfNeeded()
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers.first {
            constraintViewControllerPosition?.isActive = false
            constraintViewControllerBottom?.isActive = true
            viewTabBar.isHidden = false
            constraintViewTabBarHeight?.constant = viewTabBarHeight
            view.layoutIfNeeded()
        }
    }
    
}

extension STabBarController {
    
    @objc open func didSelected(index: Int, viewController: SViewController) {
        preconditionFailure("This method must be overridden")
    }
    
    @objc open func addViewCustom(_ view: UIView) {
        self.viewCustom.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingToSuperview()
        view.topToSuperview()
        view.trailingToSuperview()
        view.bottomToSuperview()
    }
    
}
