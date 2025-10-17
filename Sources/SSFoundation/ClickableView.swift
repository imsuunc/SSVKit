import UIKit
import Foundation
import ObjectiveC

public protocol ClickableView {
    func addTapGesture(_ tapGesture: @escaping () -> Void) -> Void
    func addLongPressGesture(duration: Double,_ longPressGesture: @escaping () -> Void) -> Void
}

extension UIView: ClickableView {
    
    private static var tapActionObjectHandle: UInt8 = 0
    private static var longPressActionObjectHandle: UInt8 = 1
    
    private var tapGesture: () -> Void {
        get {
            return objc_getAssociatedObject(self, &UIView.tapActionObjectHandle) as! (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &UIView.tapActionObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var longPressGesture: () -> Void {
        get {
            return objc_getAssociatedObject(self, &UIView.longPressActionObjectHandle) as! (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &UIView.longPressActionObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        tapGesture()
    }
    
    @objc private func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            longPressGesture()
        }
    }
    
    public func addTapGesture(_ tapGesture: @escaping () -> Void) {
        let tap = UITapGestureRecognizer(target: self , action: #selector(handleTapGesture))
        self.tapGesture = tapGesture
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public func addLongPressGesture(duration: Double = 0.5,_ longPressGesture: @escaping () -> Void) {
        let longPress = UILongPressGestureRecognizer(target: self , action: #selector(handleLongPressGesture))
        self.longPressGesture = longPressGesture
        longPress.minimumPressDuration = duration
        longPress.delaysTouchesBegan = true
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }
    
}
