import UIKit

public extension UITableView {
    
    var isScrolledToBottom: Bool {
        return contentOffset.y >= (contentSize.height - bounds.size.height)
    }
    
    func scrollToBottom(_ animated: Bool = true) {
        let numberOfRows = numberOfRows(inSection: numberOfSections - 1)
        if numberOfRows > 0 {
            scrollToRow(at: IndexPath(row: numberOfRows - 1, section: numberOfSections - 1), at: .bottom, animated: animated)
        }
    }
  
    func register(_ identifier: String) {
        register(UINib(nibName: identifier, bundle: .main), forCellReuseIdentifier: identifier)
    }
    
}
