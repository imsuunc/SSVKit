import UIKit

public extension UIView {
    
    func isPressed(_ isPressed: Bool) {
        if isPressed {
            let scale: CGFloat = 0.96
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.isPressed(false)
                }
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
}
