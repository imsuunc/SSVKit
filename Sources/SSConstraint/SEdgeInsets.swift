import UIKit

extension SEdgeInsets {
    
    public static func uniform(_ value: CGFloat) -> SEdgeInsets {
        return SEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    public static func top(_ value: CGFloat) -> SEdgeInsets {
        return SEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
    
    public static func left(_ value: CGFloat) -> SEdgeInsets {
        return SEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }
    
    public static func bottom(_ value: CGFloat) -> SEdgeInsets {
        return SEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    public static func right(_ value: CGFloat) -> SEdgeInsets {
        return SEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
    
    public static func horizontal(_ value: CGFloat) -> SEdgeInsets {
        return SEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }
    
    public static func vertical(_ value: CGFloat) -> SEdgeInsets {
        return SEdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }
    
}

public func + (lhs: SEdgeInsets, rhs: SEdgeInsets) -> SEdgeInsets {
    return .init(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
}
