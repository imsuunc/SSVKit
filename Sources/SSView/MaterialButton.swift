import UIKit
#if canImport(SSFoundation)
@_exported import SSFoundation
#endif

@IBDesignable
public class MaterialButton: UIView {
    
    public var onPressed: (() -> Void)? = nil {
        didSet {
            if onPressed != nil {
                gestureRecognizers?.forEach { gesture in
                    if gesture is UITapGestureRecognizer {
                        removeGestureRecognizer(gesture)
                    }
                }
                isUserInteractionEnabled = true
                addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewOnTouch)))
            }
        }
    }
    
    @IBInspectable
    public var iconSize: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var contenInsectVertical: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var contenInsectHorizontal: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    @IBInspectable
    public var isRounded: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var isBordered: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var isVertical: Bool = false {
        didSet {
            stackView.axis = isVertical ? .vertical : .horizontal
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? = .clear{
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var topColor: UIColor = .clear {
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
    public var title: String = "" {
        didSet {
            if title.isEmpty {
                self.labelTitle.isHidden = true
                return
            }
            self.labelTitle.text = title
            self.labelTitle.isHidden = false
        }
    }
    
    @IBInspectable
    public var titleColor: UIColor = .white {
        didSet {
            self.labelTitle.textColor = titleColor
        }
    }
    
    @IBInspectable
    public var titleSize: CGFloat = 12 {
        didSet {
            self.labelTitle.font = .systemFont(ofSize: titleSize)
        }
    }
    
    @IBInspectable
    public var textAlignment: NSTextAlignment = .center {
        didSet {
            self.labelTitle.textAlignment = textAlignment
        }
    }
    
    @IBInspectable
    public var imagePrefix: UIImage? {
        didSet {
            if imagePrefix == nil { return }
            self.imageViewPrefix.isHidden = false
            self.imageViewPrefix.image = imagePrefix
        }
    }
    
    @IBInspectable
    public var imagePrefixTint: UIColor = .label {
        didSet {
            self.imageViewPrefix.tintColor = imagePrefixTint
        }
    }
    
    @IBInspectable
    public var imageSuffix: UIImage? {
        didSet {
            if imageSuffix == nil { return }
            self.imageViewSuffix.isHidden = false
            self.imageViewSuffix.image = imageSuffix
        }
    }
    
    @IBInspectable
    public var imageSuffixTint: UIColor = .label {
        didSet {
            self.imageViewSuffix.tintColor = imageSuffixTint
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            labelTitle.font = font
        }
    }
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageViewPrefix: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = false
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private lazy var imageViewSuffix: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = false
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private var stackView = UIStackView()
    
    private var gradientLayer: CAGradientLayer?
   
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        imageViewPrefix.isHidden = imagePrefix == nil
        imageViewSuffix.isHidden = imageSuffix == nil
        labelTitle.isHidden = title.isEmpty
        stackView = UIStackView(arrangedSubviews: [imageViewPrefix, labelTitle, imageViewSuffix])
        stackView.isUserInteractionEnabled = false
        stackView.spacing = 4
        stackView.axis = isVertical ? .vertical : .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        addSubview(stackView)
        stackView.leadingToSuperview(offset: contenInsectHorizontal)
        stackView.trailingToSuperview(offset: contenInsectHorizontal)
        stackView.topToSuperview(offset: contenInsectVertical)
        stackView.bottomToSuperview(offset: -contenInsectVertical)
        imageViewPrefix.aspectRatio(1, priority: .defaultLow)
        imageViewSuffix.aspectRatio(1, priority: .defaultLow)
        if iconSize != 0 {
            stackView.alignment = .center
            imageViewPrefix.height(iconSize)
            imageViewSuffix.height(iconSize)
        }
        labelTitle.height(min: 20, priority: .defaultHigh)
        stackView.height(min: 24)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if topColor != UIColor.clear && bottomColor != UIColor.clear {
            backgroundColor = .clear
            gradientLayer = layer as? CAGradientLayer
            gradientLayer?.colors = [topColor.cgColor, bottomColor.cgColor]
            gradientLayer?.startPoint = CGPoint(x: startPointX, y: startPointY)
            gradientLayer?.endPoint = CGPoint(x: endPointX, y: endPointY)
            if isRounded {
                gradientLayer?.cornerRadius = bounds.height/2
            } else {
                layer.cornerRadius = cornerRadius
            }
            if isBordered {
                gradientLayer?.borderWidth = borderWidth
                gradientLayer?.borderColor = borderColor?.cgColor ?? UIColor.clear.cgColor
            } else {
                gradientLayer?.borderWidth = 0
                gradientLayer?.borderColor = UIColor.clear.cgColor
            }
        } else {
            if isRounded {
                layer.cornerRadius = bounds.height/2
            } else {
                layer.cornerRadius = cornerRadius
            }
            if isBordered {
                layer.borderWidth = borderWidth
                layer.borderColor = borderColor?.cgColor ?? UIColor.clear.cgColor
            } else {
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
            }
            layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
}

private extension MaterialButton {
    
    @objc private func viewOnTouch() {
        isPressed(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.onPressed?()
        }
    }
    
}
