//
//  CommonUtil.swift

import AdSupport
import CommonCrypto
import typealias CommonCrypto.CC_LONG
import func CommonCrypto.CC_MD5
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import CoreLocation
import Foundation
import SwiftKeychainWrapper
import SwiftyJSON
import UIKit

class CommonUtil {
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
    
    static func getAppVersion() -> String! {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
    // 번들아이디 얻기
    static func getAppBundleID() -> String! {
        return Bundle.main.bundleIdentifier
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
        var idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return idfa
    }
    
    static func topViewController() -> UIViewController? {
        var topVC: UIViewController? = UIApplication.shared.keyWindow!.rootViewController
        while topVC != nil, topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        
        return topVC
    }
    
    static func validEmail(_ exp: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: exp)
    }
    
    static func validUrl(_ string: String?) -> Bool {
        if string != nil, let url = URL(string: string!) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
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
    
    static func isExistSpecilChar(str: String) -> Bool {
//    let characterset = NSCharacterSet(charactersIn: "!@$%^&*()_+-=[]{};':,.<>?~`")
//    if str.rangeOfCharacter(from: characterset.inverted) == nil {
//      print("string contains special characters")
//      return true
//    } else {
//      return false
//    }
        let regx = "!@$%^&*()_+-=[]{};':,.<>?~`₩¥$£\\"
        for chr in str {
            if regx.contains(chr) {
                return false
            }
        }
        return true
    }
    
    static func isExistEngNumChar(str: String) -> Bool {
        let regx = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for chr in str {
            if !regx.contains(chr) {
                return false
            }
        }
        return true
    }
    
    static func isExistNumChar(str: String) -> Bool {
        let regx = "0123456789"
        for chr in str {
            if regx.contains(chr) {
                return true
            }
        }
        return false
    }
    
    static func isExistEngChar(str: String) -> Bool {
        let regx = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for chr in str {
            if regx.contains(chr) {
                return true
            }
        }
        return false
    }
    
    // 공백 체크
    static func isExistBackspace(str: String) -> Bool {
        for chr in str {
            if chr == " " {
                return true
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
    
    static func removeAllSubviews(_ view: UIView) {
        for item in view.subviews {
            item.removeFromSuperview()
        }
    }
    
    static func getLineCount(_ label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString
        
        let rect = CGSize(width: UIScreen.main.bounds.size.width - 20, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    //////////////////////////////////////////////////////////////////////
    
    // MARK: - load & store value
    
    //////////////////////////////////////////////////////////////////////
    
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
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(data, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    public static func getDateFromStamp(_ time: Int, type: String) -> String! {
        let date = NSDate(timeIntervalSince1970: TimeInterval(time) / 1000)
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.timeZone = TimeZone(abbreviation: "KST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = type // Specify your format that you want
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /**
     * Get the string of second time
     */
    static func diffTime4(_ p_sec: Int) -> String {
        let curTimestamp = NSDate().timeIntervalSince1970
        var w_nMillis = Int64(curTimestamp * 1000 - TimeInterval(p_sec))
//    var w_nMillis: Int64 = Int64(p_sec) * 1000
        
        let w_nDays: Int64 = w_nMillis / (24 * 3600 * 1000)
        w_nMillis -= w_nDays * (24 * 3600 * 1000)
        let w_nHours: Int64 = w_nMillis / (3600 * 1000)
        w_nMillis -= w_nHours * (3600 * 1000)
        let w_nMins: Int64 = w_nMillis / (60 * 1000)
        w_nMillis -= w_nMins * (60 * 1000)
        let w_nSecs: Int64 = w_nMillis / 1000
        
        var w_strRet = ""
        
        if w_nDays > 0 {
            if w_nDays >= 30 {
                let date = Date(timeIntervalSince1970: TimeInterval(p_sec) / 1000)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = .current
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy.MM.dd"
                w_strRet = dateFormatter.string(from: date)
            } else {
                w_strRet = String(format: "%dd ago", w_nDays)
            }
            
        } else if w_nHours > 0 {
            w_strRet = String(format: "%dh ago", w_nHours)
        } else if w_nMins > 0 {
            w_strRet = String(format: "%dm ago", w_nMins)
        } else if w_nSecs > 0 {
            w_strRet = String(format: "%ds ago", w_nSecs)
        } else {
            w_strRet = String("Just now")
        }
        
        return w_strRet
    }
    
    /**
     * Get the string of diff time
     */
    static func diffTime(_ p_sec: Int) -> String {
//        var w_nDiffMillis: Int64 = Int64(p_sec) * 1000
        
        let curTimestamp = NSDate().timeIntervalSince1970
        let time = Int64(curTimestamp - (TimeInterval(p_sec) / 1000))
        var w_nDiffMillis = time * 1000
        
        let w_nWeeks = w_nDiffMillis / (7 * 24 * 3600 * 1000)
        w_nDiffMillis -= w_nWeeks * (7 * 24 * 3600 * 1000)
        let w_nDiffDays: Int64 = w_nDiffMillis / (24 * 3600 * 1000)
        w_nDiffMillis -= w_nDiffDays * (24 * 3600 * 1000)
        let w_nDiffHours: Int64 = w_nDiffMillis / (3600 * 1000)
        w_nDiffMillis -= w_nDiffHours * (3600 * 1000)
        let w_nDiffMins: Int64 = w_nDiffMillis / (60 * 1000)
        w_nDiffMillis -= w_nDiffMins * (60 * 1000)
        let w_nDiffSeconds: Int64 = w_nDiffMillis / 1000
        
        var w_strExpression = ""
        
        let date = Date(timeIntervalSince1970: TimeInterval(p_sec) / 1000)
        let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") // Set timezone that you want
        dateFormatter.timeZone = .current
        dateFormatter.locale = NSLocale.current // Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy" // Specify your format that you want
        let strYear = dateFormatter.string(from: date)
        let strCurrentYear = dateFormatter.string(from: Date())
        
        if strYear != strCurrentYear {
            dateFormatter.dateFormat = "yyyy.MM.dd"
            w_strExpression = dateFormatter.string(from: date)
        } else if w_nWeeks > 0 {
            w_strExpression = String(format: "%dd ago", w_nDiffDays)
        } else if w_nDiffDays > 0 {
            w_strExpression = String(format: "%dd ago", w_nDiffDays)
        } else if w_nDiffHours > 0 {
            w_strExpression = String(format: "%dh ago", w_nDiffHours)
        } else if w_nDiffMins > 0 {
            w_strExpression = String(format: "%dm ago", w_nDiffMins)
        } else if w_nDiffSeconds >= 0 {
            // w_strExpression = String(format:"%dsec", w_nDiffSeconds)
            w_strExpression = "Just now"
        }
        
        return w_strExpression
    }
    
    // 2019-01-06 00:00:00 -> 2019.01.06 PM 00:00
    static func convertUpdateTime(strDate: String) -> String {
        var makeDateTime = ""
        let arrDates = strDate.components(separatedBy: " ")
        
        let makeDate = arrDates[0].replacingOccurrences(of: "-", with: ".", options: .literal, range: nil)
        let time = arrDates[1]
        let hour = time[time.index(time.startIndex, offsetBy: 0)..<time.index(time.endIndex, offsetBy: -6)]
        let min = time[time.index(time.startIndex, offsetBy: 3)..<time.index(time.endIndex, offsetBy: -3)]
        let nHour = Int(hour)
        if nHour! > 12 {
            makeDateTime = String(format: "%@ %@ %02d:%@", makeDate, "pm".localized, nHour! - 12, String(min))
        } else {
            makeDateTime = String(format: "%@ %@ %02d:%@", makeDate, "am".localized, nHour!, String(min))
        }
        
        return makeDateTime
    }
    
    /**
     * 날짜차 계산
     */
    static func diffDay(_ p_sec: Int) -> Int {
        let curTimestamp = NSDate().timeIntervalSince1970
        let time = Int64(curTimestamp - (TimeInterval(p_sec) / 1000))
        
        let day = Int(time / 60 / 60 / 24)
        
        return day
    }
    
    /**
     * 시간차 계산
     */
    static func diffHour(_ p_sec: Int) -> Int {
        let curTimestamp = NSDate().timeIntervalSince1970
        let time = Int64(curTimestamp - (TimeInterval(p_sec) / 1000))
        
        let hour = Int(time / 60 / 60)
        
        return hour
    }
    
    static func convertNum(data: String) -> String! {
        var result: String = ""
        
        let arr = data.components(separatedBy: "-")
        result = String(format: "%@-%@-%@-%@", arr[0], "****", arr[2], "****")
        
        return result
    }
    
    // phone num format  3-4-4
    static func getDashPhoneNum(num: String) -> String! {
        var result: String = ""
        
        let last_char = String(num.suffix(1))
        if last_char == "-" {
            result = String(num.prefix(num.count - 1))
        } else {
            if num.count == 4 {
                let first = String(num[num.index(num.startIndex, offsetBy: 0)..<num.index(num.startIndex, offsetBy: 3)])
                let second = String(num.suffix(1))
                
                result = String(format: "%@-%@", first, second)
            } else if num.count == 9 {
                let first = String(num[num.index(num.startIndex, offsetBy: 0)..<num.index(num.startIndex, offsetBy: 3)])
                let second = String(num[num.index(num.startIndex, offsetBy: 4)..<num.index(num.startIndex, offsetBy: 8)])
                let third = String(num.suffix(1))
                
                result = String(format: "%@-%@-%@", first, second, third)
            } else {
                result = num
            }
        }
        
        return result
    }
    
    // 문자열에서 링크 얻어내기
    static func extractLinks(data: String) -> [String] {
        var arrLinks: [String] = []
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: data, options: [], range: NSRange(location: 0, length: data.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: data) else { continue }
            let url = data[range]
            print(url)
//      let makeurl = url.lowercased()
//      if makeurl.contains("https://") || makeurl.contains("http://") {
//        arrLinks.append(String(url))
//      }
            arrLinks.append(String(url))
        }
        return arrLinks
    }
    
    // 두 지점 사이 거리
    static func getDistanceFromPlace(startlat: Double, startlng: Double, endlat: Double, endlng: Double) -> Double {
        var result = 0.0
        
        if startlat == 0 || startlng == 0 || endlat == 0 || endlng == 0 {
            return result
        }
        
        let coordinate₀ = CLLocation(latitude: startlat, longitude: startlng)
        let coordinate₁ = CLLocation(latitude: endlat, longitude: endlng)
        result = coordinate₀.distance(from: coordinate₁) / 1000
        
        return result
    }
    
    static func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func sha256(string: String) -> String? {
        guard let messageData = string.data(using: String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int) -> ()) {
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    static func getPlayTime(info: ModelSMatch) -> String {
        let makeDate = info.start_date + " " + info.start_time.substring(to: 5)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startDate = dateFormatter.date(from: makeDate)!

        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: info.time_length, to: startDate)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        let endDate = dateFormatter1.string(from: newDate!)
        
        return info.start_time.substring(to: 5) + " ~ " + endDate
    }
    
    
    //11월 30일 수요일 11:00~13:00(1시간)
    static func getPlayTime1(data: ModelSMatch) -> String {
        let month = data.start_date.components(separatedBy: "-")[1]
        let day = data.start_date.components(separatedBy: "-")[2]
        let WEEKS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let strWeek = WEEKS[data.day]

        let makeDate = data.start_date + " " + data.start_time.substring(to: 5)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startDate = dateFormatter.date(from: makeDate)!

        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: data.time_length, to: startDate)

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        let endTime = dateFormatter1.string(from: newDate!)
        let startTime = String(data.start_time.prefix(5)).replaceAll("-", with: ":")

        let diffHour = data.time_length / 60
        let diffMin = data.time_length % 60
        var result = ""
        if diffMin == 0 {
            result = String(format: "%@/%@ %@ %@~%@(%d%@)", month, day, strWeek, startTime, endTime, diffHour, "hour".localized)
        } else {
            result = String(format: "%@/%@ %@ %@~%@(%d%@ %d%@)", month, day, strWeek, startTime, endTime, diffHour, "hour".localized, diffMin, "min".localized)
        }
        
        return result
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first

        let bottomPadding = keyWindow?.safeAreaInsets.bottom
        return bottomPadding! > 0
    }
}
