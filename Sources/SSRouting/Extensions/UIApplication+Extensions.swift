import UIKit

public extension UIApplication {
    
    class var window: UIWindow? {
        if #available(iOS 15.0, *) {
            let connectedScenes = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
            let window = connectedScenes.first?
                .windows
                .first { $0.isKeyWindow }
            return window
        } else {
            return UIApplication.shared.windows.first
        }
    }
    
}
