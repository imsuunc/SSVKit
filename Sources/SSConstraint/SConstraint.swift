import UIKit

public typealias SView = UIView
public typealias SEdgeInsets = UIEdgeInsets
public typealias SLayoutGuide = UILayoutGuide
public typealias SLayoutPriority = UILayoutPriority
public typealias SConstraintAxis = NSLayoutConstraint.Axis

public typealias SConstraint = NSLayoutConstraint
public typealias SConstraints = [SConstraint]

public enum SConstraintRelation: Int {
    case equal = 0
    case equalOrLess = -1
    case equalOrGreater = 1
}

public protocol SConstrainable {
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }

    @discardableResult
    func prepareForLayout() -> Self
    
}

public struct SLayoutEdge: OptionSet {
    public let rawValue: UInt8
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    public static let top = SLayoutEdge(rawValue: 1 << 0)
    public static let bottom = SLayoutEdge(rawValue: 1 << 1)
    public static let trailing = SLayoutEdge(rawValue: 1 << 2)
    public static let leading = SLayoutEdge(rawValue: 1 << 3)
    public static let left = SLayoutEdge(rawValue: 1 << 4)
    public static let right = SLayoutEdge(rawValue: 1 << 5)
    public static let none = SLayoutEdge(rawValue: 1 << 6)
}

public extension SConstraint {
    
    @objc
    func with(_ p: SLayoutPriority) -> Self {
        priority = p
        return self
    }
    
    func set(_ active: Bool) -> Self {
        isActive = active
        return self
    }
    
}

public extension Collection where Iterator.Element == SConstraint {
    
    func activate() {
        
        if let constraints = self as? SConstraints {
            SConstraint.activate(constraints)
        }
    }
    
    func deActivate() {
        
        if let constraints = self as? SConstraints {
            SConstraint.deactivate(constraints)
        }
    }
    
}

extension SView: SConstrainable {
    
    @discardableResult
    public func prepareForLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
}

extension SLayoutGuide: SConstrainable {
    
    @discardableResult
    public func prepareForLayout() -> Self { return self }
    
}
