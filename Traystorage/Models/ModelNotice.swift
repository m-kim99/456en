import Foundation
import SwiftyJSON

public class ModelNotice: ModelBase {
    var notice_id: Int = -1
    var noticeCode: String!
    var platform: Int = 0
    var title: String!
    var content: String!
    var status: String!
    var create_time: String!
    var reg_time: String!
    var view_count: Int = 0
    
    override init(_ json: JSON) {
        super.init(json)
        notice_id = json["id"].intValue
        noticeCode = json["code"].stringValue
        platform = json["platform"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
        status = json["status"].stringValue
        create_time = json["create_time"].stringValue
        reg_time = json["reg_time"].stringValue
        view_count = json["view_count"].intValue
    }
}


public class ModelNoticeList: ModelBase {
    var list = [ModelNotice]()
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["list"]
        if arr != .null {
            for (_, m) in arr {
                list.append(ModelNotice(m))
            }
        }
    }
}
