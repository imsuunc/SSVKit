import UIKit

public protocol Identifiable: Hashable {
    var identity: AnyHashable { get }
}

public struct CVComparableDataSource<SectionIdentifierType: Hashable, ItemType: Identifiable> {
    private struct ItemIdentifierType: Hashable, Identifiable {
        var value: ItemType
        init(_ value: ItemType) {
            self.value = value
        }
        
        var identity: AnyHashable {
            return value.identity
        }
        
        static func == (_ a: ItemIdentifierType, _ b: ItemIdentifierType) -> Bool {
            return a.identity == b.identity
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identity)
        }
    }
    
    private let dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
    private let collectionView: UICollectionView
    private let cellUpdater: CellUpdater
    
    public typealias CellProvider = (UICollectionView, IndexPath, ItemType) -> UICollectionViewCell?
    public typealias CellUpdater = (UICollectionView, UICollectionViewCell, IndexPath, ItemType) -> Void
    
    public init(collectionView: UICollectionView, cellProvider: @escaping CellProvider, cellUpdater: @escaping CellUpdater) {
        self.collectionView = collectionView
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let cell = cellProvider(collectionView, indexPath, item.value) else { return nil }
            cellUpdater(collectionView, cell, indexPath, item.value)
            return cell
        }
        self.cellUpdater = cellUpdater
    }
    
    public func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemType>, animatingDifferences: Bool = true) {
        // The items currently visible
        // We shouldn't need to update anything offscreen since it will get a new cell even if it moves into view
        let visibleItemIdentifiers = collectionView.indexPathsForVisibleItems
            .compactMap({ dataSource.itemIdentifier(for: $0) })
        
        // The item identifiers that are not causing a new cell to be created, but have an updated value
        var updatedItemIdentifiers: [ItemIdentifierType] = []
        
        // We need to convert the snapshot types, even though this is sort of a no-op
        var converted = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        for section in snapshot.sectionIdentifiers {
            converted.appendSections([section])
            let itemIdentifiers = snapshot.itemIdentifiers(inSection: section).map({ ItemIdentifierType($0) })
            
            // Any of these items that are in the visibleItemIdentifiers (defined by identity) but have a different value
            updatedItemIdentifiers.append(contentsOf: itemIdentifiers
                .filter({ itemIdentifier in
                    visibleItemIdentifiers.first(where: { $0 == itemIdentifier })?.value != itemIdentifier.value
                }))
            
            converted.appendItems(itemIdentifiers, toSection: section)
        }
        
        let updates = {
            // Only updating the cells that have changed values and are on screen
            // Everything else is either unchanged or will get a complete cell refresh
            for itemIdentifier in updatedItemIdentifiers {
                guard let indexPath = dataSource.indexPath(for: itemIdentifier) else { continue }
                guard let cell = collectionView.cellForItem(at: indexPath) else { continue }
                
                self.cellUpdater(collectionView, cell, indexPath, itemIdentifier.value)
            }
        }
        
        if animatingDifferences {
            UIView.animate(withDuration: 0.2, animations: updates)
        } else {
            updates()
        }
        dataSource.apply(converted, animatingDifferences: animatingDifferences)
    }
    
}
