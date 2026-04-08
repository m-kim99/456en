import Foundation

extension NSObject {
    static var Id: String {
        return String(describing: self)
    }
}
