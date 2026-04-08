import AdSupport
import Foundation
import SwiftKeychainWrapper
import SwiftyJSON
import UIKit

class DateTimeUtils {
    public static func getDateFromStamp(_ time: Int, type: String) -> String! {
        let date = NSDate(timeIntervalSince1970: TimeInterval(time) / 1000)
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        // dateFormatter.timeZone = TimeZone(abbreviation: "KST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = type // Specify your format that you want
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
      
    static func diffTime(_ p_sec: Int) -> String {
        let curTimestamp = NSDate().timeIntervalSince1970
        let time: Int64 = Int64(curTimestamp - (TimeInterval(p_sec) / 1000))
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
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") // Set timezone that you want
        dateFormatter.timeZone = .current
        dateFormatter.locale = NSLocale.current // Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy" // Specify your format that you want
        let strYear = dateFormatter.string(from: date)
        let strCurrentYear = dateFormatter.string(from: Date())

        if strYear != strCurrentYear {
            dateFormatter.dateFormat = "yyyy.MM.dd"
            w_strExpression = dateFormatter.string(from: date)
        } else if w_nWeeks > 0 {
            w_strExpression = String(format: "%d일전", w_nDiffDays)
        } else if w_nDiffDays > 0 {
            w_strExpression = String(format: "%d일전", w_nDiffDays)
        } else if w_nDiffHours > 0 {
            w_strExpression = String(format: "%d시간전", w_nDiffHours)
        } else if w_nDiffMins > 0 {
            w_strExpression = String(format: "%d분전", w_nDiffMins)
        } else if w_nDiffSeconds >= 0 {
            // w_strExpression = String(format:"%dsec", w_nDiffSeconds)
            w_strExpression = "방금"
        }

        return w_strExpression
    }
        
    static func currentDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") // Set timezone that you want
        dateFormatter.timeZone = .current
        dateFormatter.locale = NSLocale.current // Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format // Specify your format that you want
        return dateFormatter.string(from: Date())
    }
     
    static func diffDay(_ p_sec: Int) -> Int {
        let curTimestamp = NSDate().timeIntervalSince1970
        let time: Int64 = Int64(curTimestamp - (TimeInterval(p_sec) / 1000))
        let day: Int = Int(time / 60 / 60 / 24)
        return day
    }
      
    static func diffHour(_ p_sec: Int) -> Int {
        let curTimestamp = NSDate().timeIntervalSince1970
        let time: Int64 = Int64(curTimestamp - (TimeInterval(p_sec) / 1000))
        let hour: Int = Int(time / 60 / 60)
        return hour
    }
      
    // phone num format  3-4-4
    static func getDashPhoneNum(num: String) -> String! {
        var result: String = ""
        if num.count == 11 {
            let first: String = String(num[num.index(num.startIndex, offsetBy: 0)..<num.index(num.startIndex, offsetBy: 3)])
            let second: String = String(num[num.index(num.startIndex, offsetBy: 3)..<num.index(num.startIndex, offsetBy: 7)])
            let third: String = String(num[num.index(num.startIndex, offsetBy: 7)..<num.index(num.startIndex, offsetBy: 11)])
      
            result = String(format: "%@-%@-%@", first, second, third)
        } else {
            result = num
        }

        return result
    }
    
    static func convertDateToString(_ date: Date) -> String{
        let dtFmt = DateFormatter()
        dtFmt.dateFormat = "YYYY-MM-dd"
        
        let strRet = dtFmt.string(from: date)
        return strRet
    }
    
    static func getDateString(_ strDate: String) -> String {
        let dtFmt = DateFormatter()
        dtFmt.dateFormat = "YYYY-MM-dd"
        var strRet: String = strDate
        if let date = dtFmt.date(from: strDate) {
            strRet = dtFmt.string(from: date)
        }
        return strRet
    }
    
    static func getDateTimeString(_ strDate: String) -> String {
        let dtFmt = DateFormatter()
        dtFmt.dateFormat = "YYYY-MM-dd HH:mm:ss"
        var strRet: String = strDate
        if let date = dtFmt.date(from: strDate) {
            dtFmt.dateFormat = "YYYY-MM-dd HH:mm"
            strRet = dtFmt.string(from: date)
        }
        return strRet
    }
}
