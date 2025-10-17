import UIKit

public extension UICollectionView {
    
    var isScrolledToBottom: Bool {
        return contentOffset.y >= (contentSize.height - bounds.size.height)
    }
    
    func scrollToBottom(_ animated: Bool = true) {
        let numberOfRows = numberOfItems(inSection: numberOfSections - 1)
        if numberOfRows > 0 {
            scrollToItem(at: IndexPath(item: numberOfRows - 1, section: numberOfSections - 1), at: .bottom, animated: animated)
        }
    }
    
    func register(_ identifier: String) {
        register(UINib(nibName: identifier, bundle: .main), forCellWithReuseIdentifier: identifier)
    }
    
}
