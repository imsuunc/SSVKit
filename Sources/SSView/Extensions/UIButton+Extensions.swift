import UIKit

public extension UIButton {

    @IBInspectable
    var isStrikethrough: Bool {
        set {
            if newValue {
                guard let text = title(for: .normal) else { return }
                let textRange = NSRange(location: 0, length: text.count)
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.strikethroughStyle,
                                            value: NSUnderlineStyle.single.rawValue,
                                            range: textRange)
                setAttributedTitle(attributedText, for: .normal)
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
                guard let text = title(for: .normal) else { return }
                let textRange = NSRange(location: 0, length: text.count)
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.underlineStyle,
                                            value: NSUnderlineStyle.single.rawValue,
                                            range: textRange)
                setAttributedTitle(attributedText, for: .normal)
            }
        }
        @available(*, unavailable)
        get {
            fatalError("VARIABLE CAN NOT READ.")
        }
    }
    
}


public extension UIButton {
    
    @IBInspectable
    var localizedTitle: String {
        set {
            setTitle(NSLocalizedString(newValue, comment: ""), for: .normal)
        }
        get {
            return NSLocalizedString(title(for: .normal) ?? "", comment: "")
        }
    }
    
}
