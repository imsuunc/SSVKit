import UIKit
import Combine

public extension UIView {
    
    func addTapGesture(_ target: Any?,_ selector: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
    }
    
    func addPanGesture(_ target: Any?,_ selector: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: target, action: selector))
    }
    
    func addPinchGesture(_ target: Any?,_ selector: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UIPinchGestureRecognizer(target: target, action: selector))
    }

}
