//
//  ModelDocument.swift
//  Traystorage
//
//

import Foundation
import SwiftyJSON
import UIKit

class ModelAgreement: ModelBase {
    var agree_id : Int = -1
    var title: String = ""
    var content: String = ""
    var status : Int = 0
        
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        agree_id = json["id"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
        status = json["status"].intValue
    }
}


public class ModelAgreementList: ModelList {
    var terms = [ModelAgreement]()
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["list"]
        if arr != .null {
            for (_, m) in arr {
                terms.append(ModelAgreement(m))
            }
        }
    }
}
