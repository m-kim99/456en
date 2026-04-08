import Foundation
import UIKit

extension String {
  
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
  
    var escaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
  
    func localizedWithComment(comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
  
    func widthToFit(_ height: CGFloat, _ font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
  
    func heightToFit(_ width: CGFloat, _ font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
  
    mutating func matches(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
  
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
  
    var html2AttStr: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: Data(utf8),
                                                 options: [.documentType: NSAttributedString.DocumentType.html,                                                                       .characterEncoding: String.Encoding.utf8.rawValue],
                                                 documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
  
    var html2Str: String {
        return html2AttStr?.string ?? ""
    }
  
    func hex2color() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
    
        if (cString.count) != 6 {
            return .gray
        }
    
        var rgbValue = UInt32(0)
        Scanner(string: cString).scanHexInt32(&rgbValue)
    
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
  
    func index(of target: String) -> Int? {
        if let range = self.range(of: target) {
            return target.distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
  
    func lastIndex(of target: String) -> Int? {
        if let range = self.range(of: target, options: .backwards) {
            return target.distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
  
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
  
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
  
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
  
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
  
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
  
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
  
    func replaceAll(_ of: String, with: String) -> String {
        return self.replacingOccurrences(of: of, with: with, options: .literal, range: nil)
    }
  
    func replaceFirst(_ target: String, withString replaceString: String) -> String {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    
    func hasDigit() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let re = ".*[0-9]+.*"
        let test = NSPredicate(format: "SELF MATCHES %@", re)
        return test.evaluate(with: self)
    }
    
    func hasSpecial() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let re = ".*[!@$%^&*()_+-=[]{};':,.<>?~`₩¥$£\\]+.*"
        let test = NSPredicate(format: "SELF MATCHES %@", re)
        return test.evaluate(with: self)
    }
    
    func hasCharacters() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let re = ".*[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ]+.*"
        let test = NSPredicate(format: "SELF MATCHES %@", re)
        if test.evaluate(with: self) {
            return true
        }
        
        return hasSpecial()
    }
    
    func hasSpace() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let re = ".*[\\s]+.*"
        let test = NSPredicate(format: "SELF MATCHES %@", re)
        return test.evaluate(with: self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return self.htmlToAttributedString?.string ?? ""
    }
}
