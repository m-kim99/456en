import AdSupport
import Foundation
import SwiftKeychainWrapper
import SwiftyJSON
import UIKit

class Utils {
    static func bundleID() -> String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
  
    static func bundleVer() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
  
    static func systemVer() -> String {
        return UIDevice.current.systemVersion
    }
  
    static func buildNum() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
  
    static func modelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    
        switch identifier {
            case "iPod5,1": return "iPod Touch 5"
            case "iPod7,1": return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
            case "iPhone4,1": return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2": return "iPhone 5"
            case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
            case "iPhone7,2": return "iPhone 6"
            case "iPhone7,1": return "iPhone 6 Plus"
            case "iPhone8,1": return "iPhone 6s"
            case "iPhone8,2": return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3": return "iPhone 7"
            case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
            case "iPhone8,4": return "iPhone SE"
            case "iPhone10,1", "iPhone10,4": return "iPhone 8"
            case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6": return "iPhone X"
            case "iPhone11,2": return "iPhone XS"
            case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
            case "iPhone11,8": return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
            case "iPad5,3", "iPad5,4": return "iPad Air 2"
            case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
            case "iPad5,1", "iPad5,2": return "iPad Mini 4"
            case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return "iPad Pro"
            case "AppleTV5,3": return "Apple TV"
            case "i386", "x86_64": return "Simulator"
            default: return identifier
        }
    }
  
    static func deviceName() -> String {
        return UIDevice.current.name
    }
  
    static func deviceUUID() -> String! {
        return UIDevice.current.identifierForVendor!.uuidString
    }
  
    static func deviceIDFA() -> String! {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
  
    static func topViewController() -> UIViewController? {
        var topVC: UIViewController? = UIApplication.shared.keyWindow!.rootViewController
        while topVC != nil, topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
    
        return topVC
    }
  
    static func formatNum(_ val: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter.string(from: NSNumber(value: val))!
    }
  
    static func formatNum(_ val: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter.string(from: NSNumber(value: val))!
    }
  
    static func formatNum(_ val: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter.string(from: NSNumber(value: val))!
    }
  
    static func phaseFullName(fullName: String!) -> [String] {
        var arrRet = ["", ""]
    
        if fullName != nil, fullName != "" {
            arrRet = fullName.split { $0 == " " }.map(String.init)
        }
    
        return arrRet
    }
  
    // check http url
    static func verifyUrl(urlString: String?) -> Bool {
        // Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
  
    static func callPhone(_ strPhone: String) {
        let formatedNumber = strPhone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if let url = URL(string: "tel://\(formatedNumber)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
  
    static func getLineCount(_ label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString
    
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font as Any], context: nil)
    
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    static func arrayToJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
