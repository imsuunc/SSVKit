import UIKit

public enum PanModalHeight {
    case maxHeight
    case contentHeight(CGFloat)
    case intrinsicHeight
}

public protocol PanModalPresentable: AnyObject {
    var panScrollable: UIScrollView? { get }
    var shortFormHeight: PanModalHeight { get }
    var longFormHeight: PanModalHeight { get }
    var backgroundColor: UIColor { get }
    var allowsDragToExpand: Bool { get }
    var allowsDragToDismiss: Bool { get }
    var allowsTapToDismiss: Bool { get }
    var dismissThreshold: CGFloat { get }
    var cornerRadius: CGFloat { get }
    
    func panLayoutIfNeeded(_ animated: Bool)
}

public extension PanModalPresentable {
    var panScrollable: UIScrollView? { nil }
    var allowsDragToExpand: Bool { true }
    var allowsDragToDismiss: Bool { true }
    var allowsTapToDismiss: Bool { true }
    var backgroundColor: UIColor { .systemBackground }
    var dismissThreshold: CGFloat { 0.2 }
    var cornerRadius: CGFloat { 32 }
}

public extension PanModalPresentable where Self: UIViewController {

    func panLayoutIfNeeded(_ animated: Bool = false) {
        (parent as? PanModalViewController)?.panLayoutIfNeeded(animated)
    }
    
}

private class PanModalViewController: UIViewController {
    
    private weak var delegate: PanModalPresentable?
    private var scrollObserver: NSKeyValueObservation?
    private var containerHeightConstraint: NSLayoutConstraint?
    private var containerHeight: CGFloat = 0
    private let containerView = UIView()
    
    init(delegate: PanModalPresentable) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        scrollObserver?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurBackground()
        setupContainerView()
        setupGesture()
        setupChild()
    }
    
    private func setupBlurBackground() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.4
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupContainerView() {
        view.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.clipsToBounds = true
        containerView.backgroundColor = delegate?.backgroundColor ?? .systemBackground
        containerView.layer.cornerRadius = delegate?.cornerRadius ?? 32
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerHeight = resolveHeight(delegate?.shortFormHeight ?? .intrinsicHeight)
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerHeightConstraint!
        ])
    }
    
    private func setupChild() {
        guard let child = delegate as? UIViewController else { return }
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        child.didMove(toParent: self)
    }
    
    private func resolveHeight(_ height: PanModalHeight) -> CGFloat {
        switch height {
        case .maxHeight:
            return view.bounds.height
        case .contentHeight(let h):
            return h
        case .intrinsicHeight:
            let dismissThreshold = min(max(delegate?.dismissThreshold ?? 0, 0), 1)
            guard let child = delegate as? UIViewController else { return view.bounds.height * dismissThreshold }
            let target = CGSize(width: containerView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
            return child.view.systemLayoutSizeFitting(target,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel).height
        }
    }
    
}

extension PanModalViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = delegate?.panScrollable,
           otherGestureRecognizer == scrollView.panGestureRecognizer {
            return true
        }
        return false
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        containerView.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        tapGesture.require(toFail: panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let delegate = delegate else { return }
        let translation = gesture.translation(in: containerView)
        let scrollView = delegate.panScrollable
        if let scrollView = scrollView, scrollView.isScrolling {
            return
        }
        switch gesture.state {
        case .changed:
            if delegate.allowsDragToExpand == false { return }
            let maxHeight = resolveHeight(delegate.longFormHeight)
            let newHeight = (containerHeightConstraint?.constant ?? 0) - translation.y
            if newHeight >= 0 && newHeight <= maxHeight  {
                containerHeightConstraint?.constant = newHeight
                gesture.setTranslation(.zero, in: containerView)
            }
        case .ended, .cancelled:
            let dismissThreshold = min(max(delegate.dismissThreshold, 0), 1)
            let minHeight = min(view.bounds.height * dismissThreshold, containerHeight - 10)
            let newHeight = (containerHeightConstraint?.constant ?? 0) - translation.y
            if minHeight >= newHeight && delegate.allowsDragToDismiss {
                UIView.animate(withDuration: 0.25) {
                    self.dismiss(animated: true)
                }
            }
        default:
            break
        }
    }
    
    @objc private func handleTap() {
        guard let delegate = delegate, delegate.allowsTapToDismiss else { return }
        dismiss(animated: true)
    }
    
}

private extension PanModalViewController {
    
    func panLayoutIfNeeded(_ animated: Bool = false) {
        containerHeight = max(resolveHeight(delegate?.shortFormHeight ?? .intrinsicHeight), containerView.frame.height)
        containerHeightConstraint?.constant = containerHeight
        observe(scrollView: delegate?.panScrollable)
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }
    
    private func observe(scrollView: UIScrollView?) {
        scrollObserver?.invalidate()
        scrollObserver = scrollView?.observe(\.contentOffset, options: .new) { [weak self] scrollView, change in
            guard self?.containerView != nil else { return }
            self?.changeFrame(scrollView, change: change)
        }
    }
    
    private func changeFrame(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
        guard scrollView.isDragging else { return }
        guard let delegate = delegate else { return }

        let dismissThreshold = min(max(delegate.dismissThreshold, 0), 1)
        let minHeight = min(view.bounds.height * dismissThreshold, containerHeight - 10)
        let maxHeight = resolveHeight(delegate.longFormHeight)
        
        let offsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let velocityY = scrollView.panGestureRecognizer.velocity(in: scrollView).y
    
        let currentHeight = containerHeightConstraint?.constant ?? minHeight

        guard offsetY <= 0 else { return }
        if velocityY < 0, currentHeight < maxHeight {
            let addedHeight = abs(offsetY)
            let newHeight = min(currentHeight + addedHeight, maxHeight)
            containerHeightConstraint?.constant = newHeight
            containerHeight = newHeight
            scrollView.setContentOffset(.zero, animated: false)
            view.layoutIfNeeded()
        }
        else if velocityY > 0, currentHeight > minHeight {
            let reducedHeight = abs(offsetY)
            let newHeight = max(currentHeight - reducedHeight, minHeight)
            containerHeightConstraint?.constant = newHeight
            containerHeight = newHeight
            scrollView.setContentOffset(.zero, animated: false)
            view.layoutIfNeeded()
        }
    }
    
}

extension PanModalViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PanModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PanModalAnimationController(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PanModalAnimationController(isPresenting: false)
    }
    
}

private class PanModalPresentationController: UIPresentationController {
    
    private let dimmingView = UIView()
    private var presentable: PanModalPresentable? {
        return presentedViewController as? PanModalPresentable
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    private func setupDimmingView() {
        dimmingView.backgroundColor = .clear
        dimmingView.alpha = 0.0
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
            })
        } else {
            dimmingView.alpha = 1.0
        }
        presentable?.panLayoutIfNeeded(true)
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
            })
        } else {
            dimmingView.alpha = 0.0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.bounds ?? .zero
    }
    
}

private class PanModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            container.addSubview(toView)
            let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            toView.frame = finalFrame.offsetBy(dx: 0, dy: container.bounds.height)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame = finalFrame
            }, completion: { done in
                transitionContext.completeTransition(done)
            })
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.frame = fromView.frame.offsetBy(dx: 0, dy: container.bounds.height)
            }, completion: { done in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(done)
            })
        }
    }
}

private extension UIScrollView {
    
    var isScrolling: Bool {
        return isDragging && !isDecelerating || isTracking
    }
    
}

public extension UIViewController {
    
    func presentPan(_ controller: UIViewController & PanModalPresentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let modalViewController = PanModalViewController(delegate: controller)
        present(modalViewController, animated: animated, completion: completion)
    }
    
}
