import UIKit
#if canImport(SSFoundation)
@_exported import SSFoundation
#endif
#if canImport(SSConstraint)
@_exported import SSConstraint
#endif

@IBDesignable
open class STabBarItemView: UIView {
    
    var onTouch: (() -> Void)?
    
    @IBInspectable
    open var isSelected: Bool = false {
        didSet {
            if normalImage != nil && selectedImage != nil {
                iconView.image = isSelected ? selectedImage : normalImage
            } else {
                iconView.tintColor = isSelected ? selectedColor : normalColor
            }
            titleLabel.textColor = isSelected ? selectedColor : normalColor
        }
    }
    
    @IBInspectable
    open var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable
    open var normalImage: UIImage?
    
    @IBInspectable
    open var selectedImage: UIImage?
    
    @IBInspectable
    open var normalColor: UIColor = .white {
        didSet {
            titleLabel.textColor = normalColor
        }
    }
    
    @IBInspectable
    open var selectedColor: UIColor = .black
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.tintColor = .blue
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 11)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    public convenience init(title: String? = nil, icon: UIImage? = nil, normalColor: UIColor = .lightGray, selectedColor: UIColor = .systemBlue) {
        self.init(frame: CGRect.zero)
        titleLabel.text = title
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        if #available(iOS 13.0, *) {
            iconView.image = icon != nil ? icon : UIImage(systemName: "circle.grid.3x3.fill")
        } else {
            iconView.image = icon
        }
        isSelected = false
    }
    
    
    private func initializeView() {
        clipsToBounds = false
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.leadingToSuperview()
        titleLabel.trailingToSuperview()
        titleLabel.bottomToSuperview(offset: -4, priority: .defaultHigh)
        addSubview(iconView)
        iconView.topToSuperview(offset: 8, priority: .defaultHigh)
        iconView.bottomToTop(of: titleLabel, offset: -4, priority: .defaultHigh)
        iconView.centerXToSuperview()
        iconView.aspectRatio(1)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewOnTouch)))
    }
    
    @objc private func viewOnTouch(_ gesture: UITapGestureRecognizer) {
        isSelected = true
        onTouch?()
    }
    
}

