import Foundation
import SwiftyJSON

public class ModelUser: ModelBase {
    var id: Int = 0
    var uid: String = ""
    var email: String!
    var pwd: String!
    var name: String!
    var profile_img: String!
    var phone: String!
    var birthday = ""
    var gender: Int = 0
    var status: Int!
    var access_token: String!
    var document_cnt: Int!
    var create_time: String!
    var exit_reg_time: String!
    var stop_remark: String!

    var isAgree: Int = 0
    
    var authCode: Int!
    
    override init(_ json: JSON) {
        super.init(json)
        id = json["id"].intValue
        uid = json["login_id"].stringValue
        name = json["name"].stringValue
        phone = json["phone_number"].stringValue
        status = json["status"].intValue
        gender = json["gender"].intValue
        birthday = json["birthday"].stringValue
        email = json["email"].stringValue
        profile_img = json["profile_image"].stringValue
        create_time = json["create_time"].stringValue
        exit_reg_time = json["ext_reg_time"].stringValue
        stop_remark = json["stop_remark"].stringValue
        access_token = json["access_token"].stringValue
        document_cnt = json["document_cnt"].intValue
        isAgree = json["is_agree"].intValue
        //signup_type = json["signup_type"].intValue
    }
    
    static func isIdValid(_ id: String) -> Bool {
        if id.isEmpty || id.count < 4 || id.count > 16 {
            return false
        }
        
        if id.hasSpace() {
            return false
        }
        
        return true;
    }
    
    static func isPasswordValid(_ pwd: String) -> Bool {
        if pwd.isEmpty || pwd.count < 8 {
            return false
        }
        
        if !pwd.hasDigit() {
            return false
        }
        
        if !pwd.hasCharacters() {
            return false
        }
        
        return true;
    }
    
    static func isAuthCodeValid(code: String) -> Bool {
        if code.isEmpty || code.count != 4 {
            return false;
        }
        
        return Validations.digit(code)
    }
    
    static func isBirthdayValid(birthday: String) -> Bool {
        if birthday.isEmpty || birthday.count != 6 {
            return false
        }
        
        if !Validations.digit(birthday) {
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if dateFormatter.date(from: birthday) != nil {
            return false
        }
                
        return true
    }
}
