import UIKit

public extension UILabel {
    
    @IBInspectable
    var isStrikethrough: Bool {
        set {
            if newValue {
                guard let text = text else { return }
                let textRange = NSRange(location: 0, length: text.count)
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.strikethroughStyle,
                                            value: NSUnderlineStyle.single.rawValue,
                                            range: textRange)
                self.attributedText = attributedText
            }
        }
        @available(*, unavailable)
        get {
            fatalError("VARIABLE CAN NOT READ.")
        }
    }
    
    @IBInspectable
    var isUnderline: Bool {
        set {
            if newValue {
                guard let text = text else { return }
                let textRange = NSRange(location: 0, length: text.count)
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.underlineStyle,
                                            value: NSUnderlineStyle.single.rawValue,
                                            range: textRange)
                self.attributedText = attributedText
            }
        }
        @available(*, unavailable)
        get {
            fatalError("VARIABLE CAN NOT READ.")
        }
    }
    
}

public extension UILabel {
    
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
