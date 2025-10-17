import UIKit

public extension UITextField {
    
    @IBInspectable
    var localizedPlaceholder: String {
        set(value) {
            placeholder = NSLocalizedString(value, comment: "")
        }
        get {
            NSLocalizedString(placeholder ?? "", comment: "")
        }
    }
    
    @IBInspectable
    var localizedText: String {
        set(value) {
            text = NSLocalizedString(value, comment: "")
        }
        get {
            NSLocalizedString(text ?? "", comment: "")
        }
    }
    
}

