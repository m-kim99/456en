import Alamofire
import SwiftyJSON
import UIKit

class Net {
    private static func convVal(_ bVal: Bool) -> String {
        return bVal ? "Y" : "N"
    }
        
    //

    // MARK: API response structure

    //
    public typealias SuccessBlock = (ModelBase?) -> Void
    public typealias FailureBlock = (_ code: Int, _ err: String) -> Void
    
    // MARK: Helper functions
    
    //
    
    /**
     *  HTTP request.
     */
    public static func doRequest(
        method: Alamofire.HTTPMethod,
        api: API,
        params: [String: AnyObject],
        header: [String: String],
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let url = Server_Url + api.url
        print("\n\(url)")
        print(params)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: header).responseString { response in // .URLEncoding JSONEncoding
            switch response.result {
            case .failure(let error):
                if let failure = failure {
                    print("\nAPI Call Failed!\nURL : \(url)\nError : \(error.localizedDescription)")
                    if let data = response.data {
                        let res = String(describing: data)
                        print("Response : \(res)")
                    }
                    failure(999, "server_connect_fail".localized)
                }
                return
            case .success(let json):
                
                let res = JSON(json.data(using: .utf8)! as Any)
                print(res)
                
                let code = res["result"].intValue
                let msg = res["msg"].stringValue
                let data = res["data"]
                
                if code == 0 {
                    do {
                        let model = try ParseResponse(api: api, json: data)
                        if let success = success {
                            success(model)
                        }
                    } catch _ {
                        if let failure = failure {
                            failure(-900, "Failed to parse server response(invalid object)")
                        }
                    }
                } else {
                    if let failure = failure {
                        failure(code, msg)
                    }
                }
            }
        }
    }
    
    /**
     *  File request.
     */
    public static func doRequestForFile(
        method: Alamofire.HTTPMethod,
        api: API,
        imgArray: [Data]! = [],
        imgMarkArray: [String]! = [],
        imgMark: String = "file",
        imgIndexable: Bool = false,
        vidArray: [Data]! = [],
        vidMarkArray: [String]! = [],
        vidMark: String = "video",
        vidIndexable: Bool = false,
        params: [String: AnyObject]?,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let url = Server_Url + api.url
        print(url)
        print(params ?? "params:")
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            if imgArray.count > 0 {
                for i in 0...imgArray.count - 1 {
                    var strName = imgMark
                    if imgIndexable {
                        strName += "\(i + 1)"
                    }
                    if i < imgMarkArray.count {
                        strName = imgMarkArray[i]
                    }
                    MultipartFormData.append(imgArray[i], withName: strName, fileName: "\(strName).jpg", mimeType: "image/jpg")
                }
            }
            
            if vidArray.count > 0 {
                for i in 0...vidArray.count - 1 {
                    var strName = vidMark
                    if vidIndexable {
                        strName += "\(i + 1)"
                    }
                    if i < vidMarkArray.count {
                        strName = vidMarkArray[i]
                    }
                    MultipartFormData.append(vidArray[i], withName: strName, fileName: "\(strName).m4a", mimeType: "audio/m4a")
                }
            }
            
            for (key, value) in params! {
                let data = JSON(value).stringValue
                MultipartFormData.append(data.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, method: method, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .failure(let error):
                if let failure = failure {
                    print("\nAPI Call Failed!\nURL : \(url)\nError : \(error.localizedDescription)")
                    failure(999, "server_connect_fail".localized)
                }
                
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseString { response in
                    guard let result = response.result.value, !result.isEmpty else {
                        if let failure = failure {
                            failure(-900, "Failed to parse server response(invalid object)")
                        }
                        return
                    }

                    print(result)
                    
                    let res = JSON(result.data(using: .utf8)! as Any)
                    print(res)
                    
                    let code = res["result"].intValue
                    let msg = res["msg"].stringValue
                    let data = res["data"]
                    
                    if code == 0 {
                        do {
                            let model = try ParseResponse(api: api, json: data)
                            if let success = success {
                                success(model)
                            }
                        } catch _ {
                            if let failure = failure {
                                failure(-900, "Failed to parse server response(invalid object)")
                            }
                        }
                    } else {
                        if let failure = failure {
                            failure(code, msg)
                        }
                    }
                }
            }
        })
    }
}
