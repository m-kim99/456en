import Foundation
import SwiftyJSON

public class ModelCard: ModelBase {
    var title: String!
    var content: String!
    var reply: String!
    var status: Int!
    var regTime: String!
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        title = json["title"].stringValue
        content = json["content"].stringValue
        reply = json["reply"].stringValue
        status = json["status"].intValue
        regTime = json["reg_time"].stringValue
    }
}


public class ModelCardList: ModelBase {
    var list = [ModelCard?]()
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["list"]
        if arr != .null {
            for (_, m) in arr {
                list.append(ModelCard(m))
            }
        }
    }
}
