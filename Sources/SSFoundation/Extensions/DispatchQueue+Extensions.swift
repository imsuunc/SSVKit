import Foundation

public extension DispatchQueue {
    
    func asyncSafety(_ closure: @Sendable @escaping () -> Void) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: closure)
            return
        }
        closure()
    }
    
}
