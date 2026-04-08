//
//  ModelDocument.swift
//  Traystorage
//
//

import Foundation
import SwiftyJSON
import UIKit

class ModelDocument: ModelBase {
    var doc_id : Int = -1
    var user_id : Int = -1
    var images = [[String: Any]]()
    var title: String = ""
    var content: String = ""
    var tags:[String] = []
    
    var create_time: String = ""
    var reg_time: String = ""
    var code1: String = ""
    
    var label: Int = 0
        
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        let docJson = json["document"] // to parse insert document api
        if docJson.count > 0  {
            loadDocument(docJson)
        } else {
            loadDocument(json)
        }
    }
    
    private func loadDocument(_ json: JSON) {
        doc_id = json["id"].intValue
        user_id = json["user_id"].intValue
        title = json["title"].stringValue
        code1 = json["code"].stringValue
        content = json["content"].stringValue
        label = json["label"].intValue
        create_time = json["create_time"].stringValue
        reg_time = json["reg_time"].stringValue
        
        let tagList = json["tag_list"]
        if tagList != . null {
            for (_, tag) in tagList {
                self.tags.append(tag.stringValue)
            }
        }
        
        let imageList = json["image_list"]
        if imageList != . null {
            for (_, image) in imageList {
                addImage(url: image.stringValue)
            }
        }
    }
    
    func addImage(image:UIImage?) {
        var newItem = [String:Any]()
        newItem["image"] = image
        images.append(newItem)
    }
    
    func addImage(url: String) {
        var newItem = [String:Any]()
        newItem["url"] = url
        images.append(newItem)
    }
    
    func removeImage(at: Int) {
        images.remove(at: at)
    }
    
    func setToImageView(at: Int, imageView: UIImageView) {
        let item = images[at]
        
        if let url = item["url"] as? String {
            imageView.kf.setImage(with: URL(string: url))
        } else {
            imageView.image = item["image"] as? UIImage
        }
        imageView.contentMode = .scaleAspectFill
    }
}


public class ModelDocumentList: ModelList {
    var contents = [ModelDocument]()
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["document_list"]
        if arr != .null {
            for (_, m) in arr {
                contents.append(ModelDocument(m))
            }
        }
    }
}
