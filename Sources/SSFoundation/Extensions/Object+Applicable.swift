import Foundation

public protocol Parcelable: Codable {}

extension Parcelable {
    
    public func toDict() -> [String: Any] {
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
    
}

public protocol Applicable {
    
}

public extension Applicable {
    
    func apply(_ closure: (Self) -> ()) -> Self {
        closure(self)
        return self
    }
    
}

extension NSObject: Applicable {}

public extension Decodable {
    
    func apply(_ closure: (Self) -> ()) -> Self {
        closure(self)
        return self
    }
    
}
