import UIKit

public class UICircularView: UIView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = frame.height/2
    }
    
}

public class UICircularLabel: UILabel {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = frame.height/2
    }
    
}

public class UICircularButton: UIButton {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = frame.height/2
    }
    
}

public class UICircularImageView: UIImageView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = frame.height/2
    }
    
}
