import Foundation
import SwiftyJSON

public class ModelFAQ: ModelBase {
    var faq_id: Int = -1
    var faccode: String!
    var item_id: String!
    var platform: Int = 0
    var title: String!
    var content: String!
    var priority: Int = 0
    var status: String!
    var create_time: String!
    var item_name: String = ""
    
    override init(_ json: JSON) {
        super.init(json)
        faq_id = json["id"].intValue
        faccode = json["code"].stringValue
        item_id = json["item_id"].stringValue
        platform = json["platform"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
        priority = json["priority"].intValue
        status = json["status"].stringValue
        create_time = json["create_time"].stringValue
        item_name = json["item_name"].stringValue
    }
}

public class ModelFAQList: ModelBase {
    var list = [ModelFAQ]()
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["list"]
        if arr != .null {
            for (_, m) in arr {
                list.append(ModelFAQ(m))
            }
        }
    }
}


public class ModelFAQCategory: ModelBase {
    var faq_id: Int = -1
    var name: String = "all"._localized
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        faq_id = json["id"].intValue
        name = json["name"].stringValue
    }
}

public class ModelFAQCateList: ModelBase {
    var list = [ModelFAQCategory]()
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["list"]
        if arr != .null {
            for (_, m) in arr {
                list.append(ModelFAQCategory(m))
            }
        }
    }
}
