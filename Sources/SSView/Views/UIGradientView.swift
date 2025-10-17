import UIKit

@IBDesignable
public class UIGradientView: UIView {
    
    public var isHideGradient: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var gradientLayer: CAGradientLayer!
    
    @IBInspectable
    public var defautBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var topColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var bottomColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var shadowBlur: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float = 0 {
        didSet {
            if shadowOpacity > 1 || shadowOpacity < 0 {
                return
            }
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    open override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public override func layoutSubviews() {
        if isHideGradient {
            gradientLayer = layer as? CAGradientLayer
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
            gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
            layer.cornerRadius = cornerRadius
            backgroundColor = defautBackgroundColor
        } else {
            gradientLayer = layer as? CAGradientLayer
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
            gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
            layer.cornerRadius = cornerRadius
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
            layer.shadowRadius = shadowBlur
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    public func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        gradientLayer?.add(animation, forKey:"animateGradient")
    }
    
}
