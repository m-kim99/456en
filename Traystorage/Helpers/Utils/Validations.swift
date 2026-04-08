import Foundation
import UIKit

class Validations {
    static func email(_ value: String?) -> Bool {
        if value == nil || value!.isEmpty {
            return false
        }
        let re = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
      
        let test = NSPredicate(format: "SELF MATCHES %@", re)
        return test.evaluate(with: value)
    }
    
    // 010-1234-1234, 01012341234, 01612341234, 016-1234-1234
    static func phone(_ value: String?) -> Bool {
        if value == nil || value!.isEmpty {
            return false
        }
        let re = "^01(?:0|1|[6-9])[-\\s\\.]?[0-9]{4}[-\\s\\.]?[0-9]{4}$"
      
        let test = NSPredicate(format: "SELF MATCHES %@", re)
        return test.evaluate(with: value)
    }
    
    static func digit(_ value: String?) -> Bool {
        if value == nil || value!.isEmpty {
            return false
        }
        let re = "(^[0-9]*$)"
    
        let test = NSPredicate(format: "SELF MATCHES %@", re)
        return test.evaluate(with: value)
    }
    
    static func url(_ value: String?) -> Bool {
        if value == nil || value!.isEmpty {
            return false
        }
        if let url = URL(string: value!) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    static func isValid(password: String) -> Bool {
        return password.count >= 6
    }
}
