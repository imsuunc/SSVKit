import UIKit

public extension SConstrainable {
    
    @discardableResult
    func center(in view: SConstrainable, offset: CGPoint = .zero, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraints {
        prepareForLayout()
        
        let constraints = [
            centerX(to: view, offset: offset.x, priority: priority, isActive: isActive),
            centerY(to: view, offset: offset.y, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    @discardableResult
    func edges(to view: SConstrainable, excluding excludedEdge: SLayoutEdge = .none, insets: SEdgeInsets = .zero, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraints {
        prepareForLayout()
        
        var constraints = SConstraints()
        
        if !excludedEdge.contains(.top) {
            constraints.append(top(to: view, offset: insets.top, relation: relation, priority: priority, isActive: isActive))
        }
        
        if !excludedEdge.contains(.left) {
            constraints.append(left(to: view, offset: insets.left, relation: relation, priority: priority, isActive: isActive))
        }
        
        if !excludedEdge.contains(.bottom) {
            constraints.append(bottom(to: view, offset: -insets.bottom, relation: relation, priority: priority, isActive: isActive))
        }
        
        if !excludedEdge.contains(.right) {
            constraints.append(right(to: view, offset: -insets.right, relation: relation, priority: priority, isActive: isActive))
        }
        
        return constraints
    }
    
    @discardableResult
    func size(_ size: CGSize, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraints {
        prepareForLayout()
        
        let constraints = [
            width(size.width, relation: relation, priority: priority, isActive: isActive),
            height(size.height, relation: relation, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    @discardableResult
    func size(to view: SConstrainable, multiplier: CGFloat = 1, insets: CGSize = .zero, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraints {
        prepareForLayout()
        
        let constraints = [
            width(to: view, multiplier: multiplier, offset: insets.width, relation: relation, priority: priority, isActive: isActive),
            height(to: view, multiplier: multiplier, offset: insets.height, relation: relation, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    @discardableResult
    func origin(to view: SConstrainable, insets: SEdgeInsets = .zero, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraints {
        prepareForLayout()
        
        let constraints = [
            left(to: view, offset: insets.left, relation: relation, priority: priority, isActive: isActive),
            top(to: view, offset: insets.top, relation: relation, priority: priority, isActive: isActive)
        ]
        
        return constraints
    }
    
    @discardableResult
    func width(_ width: CGFloat, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return widthAnchor.constraint(equalToConstant: width).with(priority).set(isActive)
        case .equalOrLess: return widthAnchor.constraint(lessThanOrEqualToConstant: width).with(priority).set(isActive)
        case .equalOrGreater: return widthAnchor.constraint(greaterThanOrEqualToConstant: width).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func width(to view: SConstrainable, _ dimension: NSLayoutDimension? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return widthAnchor.constraint(equalTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return widthAnchor.constraint(lessThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return widthAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(isActive)
        }
    }

    @discardableResult
    func widthToHeight(of view: SConstrainable, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        return width(to: view, view.heightAnchor, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func width(min: CGFloat? = nil, max: CGFloat? = nil, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraints {
        prepareForLayout()
        
        var constraints: SConstraints = []
        
        if let min = min {
            let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        if let max = max {
            let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: max).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    @discardableResult
    func height(_ height: CGFloat, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return heightAnchor.constraint(equalToConstant: height).with(priority).set(isActive)
        case .equalOrLess: return heightAnchor.constraint(lessThanOrEqualToConstant: height).with(priority).set(isActive)
        case .equalOrGreater: return heightAnchor.constraint(greaterThanOrEqualToConstant: height).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func height(to view: SConstrainable, _ dimension: NSLayoutDimension? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return heightAnchor.constraint(equalTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return heightAnchor.constraint(lessThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return heightAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(isActive)
        }
    }

    @discardableResult
    func heightToWidth(of view: SConstrainable, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        return height(to: view, view.widthAnchor, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func height(min: CGFloat? = nil, max: CGFloat? = nil, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraints {
        prepareForLayout()
        
        var constraints: SConstraints = []
        
        if let min = min {
            let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        if let max = max {
            let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: max).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }
        
        return constraints
    }

    @discardableResult
    func aspectRatio(_ ratio: CGFloat, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        return widthToHeight(of: self, multiplier: ratio, offset: 0, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func leadingToTrailing(of view: SConstrainable, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        return leading(to: view, view.trailingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func leading(to view: SConstrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return leadingAnchor.constraint(equalTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return leadingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return leadingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func leftToRight(of view: SConstrainable, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        return left(to: view, view.rightAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func left(to view: SConstrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return leftAnchor.constraint(equalTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return leftAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return leftAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func trailingToLeading(of view: SConstrainable, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        return trailing(to: view, view.leadingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func trailing(to view: SConstrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return trailingAnchor.constraint(equalTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return trailingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return trailingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func rightToLeft(of view: SConstrainable, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        return right(to: view, view.leftAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func right(to view: SConstrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return rightAnchor.constraint(equalTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return rightAnchor.constraint(lessThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return rightAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func topToBottom(of view: SConstrainable, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        return top(to: view, view.bottomAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func top(to view: SConstrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return topAnchor.constraint(equalTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return topAnchor.constraint(lessThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return topAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func bottomToTop(of view: SConstrainable, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        return bottom(to: view, view.topAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func bottom(to view: SConstrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: SConstraintRelation = .equal, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        switch relation {
        case .equal: return bottomAnchor.constraint(equalTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrLess: return bottomAnchor.constraint(lessThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(isActive)
        case .equalOrGreater: return bottomAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(isActive)
        }
    }
    
    @discardableResult
    func centerX(to view: SConstrainable, _ anchor: NSLayoutXAxisAnchor? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()
        
        let constraint: SConstraint

        if let anchor = anchor {
            constraint = centerXAnchor.constraint(equalTo: anchor, constant: offset).with(priority)
        } else {
            constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: multiplier, constant: offset).with(priority)
        }

        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func centerY(to view: SConstrainable, _ anchor: NSLayoutYAxisAnchor? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, priority: SLayoutPriority = .required, isActive: Bool = true) -> SConstraint {
        prepareForLayout()

        let constraint: SConstraint

        if let anchor = anchor {
            constraint = centerYAnchor.constraint(equalTo: anchor, constant: offset).with(priority)
        } else {
            constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: multiplier, constant: offset).with(priority)
        }

        constraint.isActive = isActive
        return constraint
    }
    
}

public extension SView {
    
    func setHugging(_ priority: SLayoutPriority, for axis: SConstraintAxis) {
        setContentHuggingPriority(priority, for: axis)
    }
    
    func setCompressionResistance(_ priority: SLayoutPriority, for axis: SConstraintAxis) {
        setContentCompressionResistancePriority(priority, for: axis)
    }
    
}
