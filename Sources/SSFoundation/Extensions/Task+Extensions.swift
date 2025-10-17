import UIKit
import Combine

public extension Task {
    
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable {
            self.cancel()
        })
    }
    
}

private let tasksKey = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
public extension NSObject {
    
    func task(priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) {
        let task = Task(priority: priority, operation: action)
        
        var tasks = objc_getAssociatedObject(self, tasksKey) as? Set<AnyCancellable> ?? []
        task.store(in: &tasks)
        objc_setAssociatedObject(self, tasksKey, tasks, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}

/*
class ViewController: UIViewController {
    
    private var observers: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
        .store(in: &observers)
    }
    
}
*/
