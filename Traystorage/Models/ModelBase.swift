import Foundation
import SwiftyJSON

public class ModelBase {
    var result: Int!
    var msg: String!
    var reason: String!
    var code: String!
    var loginId: String!//find id
    var signup_type: Int = 0

    init() {}
    
    init(_ json: JSON) {
        result = json["result"].intValue
        msg = json["msg"].stringValue
        reason = json["reason"].stringValue
        code = json["code"].stringValue
        loginId = json["login_id"].stringValue
        signup_type = json["signup_type"].intValue
    }
}

public class ModelList: ModelBase {
    var total_cnt: Int!
    var page_cnt: Int!
    var is_last: Bool!
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        total_cnt = json["total_cnt"].intValue
        page_cnt = json["page_cnt"].intValue
        is_last = json["is_last"].boolValue
    }
}

public class ModelUploadFileList: ModelList {
    var fileNames = [String]()
    var fileUrls = [String]()
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        for jfile in json.arrayValue {
            fileNames.append(jfile["file_name"].stringValue)
            fileUrls.append(jfile["file_url"].stringValue)
        }
    }

}
