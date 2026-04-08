import AdSupport
import Foundation
import SwiftKeychainWrapper
import SwiftyJSON
import UIKit

class LocalStoreUtils {
    static func bool(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func setBool(_ value: Bool, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func int(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func setInt(_ value: Int, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func string(_ key: String) -> String! {
        return UserDefaults.standard.string(forKey: key) as String?
    }
    
    static func setString(_ value: String!, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func data(_ key: String) -> AnyObject! {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    static func setData(_ value: AnyObject!, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func archivedData(_ key: String) -> AnyObject! {
        if let data = UserDefaults.standard.object(forKey: key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as AnyObject?
        }
        return nil
    }
    
    static func setArchivedData(_ value: AnyObject!, forKey: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: value as Any)
        UserDefaults.standard.set(data, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
}
