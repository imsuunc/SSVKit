import UIKit

public protocol Reusable: AnyObject {
    
    static var identifier: String { get }
    
    static var nib: UINib { get }
    
}

public extension Reusable {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

public extension Reusable where Self: UIView {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
    
}

public extension UITableView {
    
    final func register<T: UITableViewCell>(cellType: T.Type)
    where T: Reusable {
        self.register(cellType.self, forCellReuseIdentifier: cellType.identifier)
    }
    
    final func registerNib<T: UITableViewCell>(cellType: T.Type)
    where T: Reusable {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }
    
    
    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)
    where T: Reusable {
        self.register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.identifier)
    }
    
    
    final func registerNib<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)
    where T: Reusable {
        self.register(headerFooterViewType.nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.identifier)
    }
    
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
    where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self). "
                + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
    
    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T?
    where T: Reusable {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.identifier) as? T? else {
            fatalError(
                "Failed to dequeue a header/footer with identifier \(viewType.identifier) "
                + "matching type \(viewType.self). "
                + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                + "and that you registered the header/footer beforehand"
            )
        }
        return view
    }
    
}

public extension UICollectionView {
    
    final func register<T: UICollectionViewCell>(cellType: T.Type)
    where T: Reusable {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    final func registerNib<T: UICollectionViewCell>(cellType: T.Type)
    where T: Reusable {
        self.register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String)
    where T: Reusable {
        self.register(
            supplementaryViewType.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: supplementaryViewType.identifier
        )
    }
    
    final func registerNib<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String)
    where T: Reusable {
        self.register(
            supplementaryViewType.nib,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: supplementaryViewType.identifier
        )
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
    where T: Reusable {
        let bareCell = self.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
        guard let cell = bareCell as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self). "
                + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
    
    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
    (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T
    where T: Reusable {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: viewType.identifier,
            for: indexPath
        )
        guard let typedView = view as? T else {
            fatalError(
                "Failed to dequeue a supplementary view with identifier \(viewType.identifier) "
                + "matching type \(viewType.self). "
                + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                + "and that you registered the supplementary view beforehand"
            )
        }
        return typedView
    }
    
}
