import Foundation
import SwiftyJSON

public class ModelPopup: ModelBase {
    var id: Int!
    var title: String!
    var contentType: Int!
    var content: String!
    var contentImage: String!
    var visibleStatus: Int!
    var closeMethod: Int = 0
    var moveType: Int = 0
    var movePath = ""
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        id = json["id"].intValue
        contentType = json["content_type"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
        contentImage = json["content_image"].stringValue
        visibleStatus = json["visible_status"].intValue
        closeMethod = json["close_method"].intValue
        moveType = json["move_type"].intValue
        movePath = json["move_path"].stringValue
    }

}

public class ModelPopupList: ModelList {
    var contents = [ModelPopup]()
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["popup_list"]
        if arr != .null {
            for (_, m) in arr {
                contents.append(ModelPopup(m))
            }
        }
    }
}
