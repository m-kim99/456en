import Alamofire
import Foundation
import SwiftyJSON
import UIKit

class Rest: Net {
    public static var user: ModelUser!

    public static func appInfo(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        doRequest(method: .post, api: .APP_INFO, params: [:], header: [:], success: success, failure: failure)
    }
    
    public static func login(
        id: String!,
        pwd: String!,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
//        let token = Local.getPushKey()
        let params = [
            "login_id": id,
            "password": pwd,
//            "dev_type": "ios",
//            "dev_token": token
        ]

        doRequest(method: .post, api: .USER_LOGIN, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func sendCertKey(
        email: String!,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "email": email
        ]

        doRequest(method: .post, api: .USER_SEND_CERTKEY_EMAIL, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func sendCertKey(
        phone: String!,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "phone": phone
        ]

        doRequest(method: .post, api: .USER_SEND_CERTKEY_PHONE, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func verifyCertKey(
        email: String!,
        certKey: String!,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "email": email,
            "cert_key": certKey
        ]

        doRequest(method: .post, api: .USER_VERIFY_CERTKEY_EMAIL, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func verifyPhoneCode(
        phone: String,
        code: String,
        isContinue: Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "phone_number": phone,
            "code": code,
            "is_continue": isContinue.description
        ]

        doRequest(method: .post, api: .USER_VERIFY_CERTKEY_PHONE, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func signup(
        login_id: String,
        pwd: String,
        phone: String,
        name: String,
        birthday: String,
        gender: Int,
        email:String,
        signup_type:Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "login_id": login_id,
            "phone_number": phone,
            "password": pwd,
            "name": name,
            "birthday": birthday,
            "gender": gender,
            "email": email,
            "signup_type": signup_type
        ] as [String: AnyObject]

        doRequest(method: .post, api: .USER_SIGNUP, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func makeProfile(
        name: String,
        birthday: String,
        gender: Int,
        email:String,
        profileImage:String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "name": name,
            "birthday": birthday,
            "gender": gender,
            "email": email,
            "profile_image": profileImage,
        ] as [String: AnyObject]
        
        doRequest(method: .post, api: .MAKE_PROFILE, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    
    public static func find_login_id(
        phoneNumber: String,
        code: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "phone_number": phoneNumber,
            "code": code
        ] as [String: AnyObject]

        doRequest(method: .post, api: .USER_FIND_ID, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func check_login_id(
        loginID: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "login_id": loginID
        ] as [String: AnyObject]

        doRequest(method: .post, api: .CHECK_LOGIN_ID, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func request_code_for_find(
        loginId: String,
        phoneNumber: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "login_id": loginId,
            "phone_number": phoneNumber
        ] as [String: AnyObject]

        doRequest(method: .post, api: .REQUEST_CODE_FIND, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func request_code_for_signup(
        phoneNumber: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "phone_number": phoneNumber
        ] as [String: AnyObject]

        doRequest(method: .post, api: .REQUEST_CODE_SIGNUP, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func findPwd(
        loginid:String,
        phoneNumber:String,
        code: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "login_id": loginid,
            "phone_number": phoneNumber,
            "code": code,
        ] as [String: AnyObject]

        doRequest(method: .post, api: .USER_FIND_PWD, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }
    
    public static func uploadFiles(
        files: [Data]!,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token
        ] as [String: AnyObject]
        
        doRequestForFile(method: .post, api: .UPLOAD_FILES, imgArray: files, imgMark: "files[]", params: params as [String: AnyObject], success: success, failure: failure)
    }
    
    public static func changePwd(
        loginID: String,
        password: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "login_id": loginID,
            "password": password,
        ] as [String: AnyObject]
        
        doRequest(method: .post, api: .CHANGE_PWD, params: params as [String: AnyObject], header: [:], success: success, failure: failure)
    }

    public static func popupInfo(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "platform": 1
        ] as [String: AnyObject]

        doRequest(method: .post, api: .POPUP_INFO, params: params, header: [:], success: success, failure: failure)
    }
    
    
    public static func documentList(
        keyword: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "keyword": keyword
        ] as [String: AnyObject]

        doRequest(method: .post, api: .DOCUMENT_LIST, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func documentDetail(
        documentID: Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "id": documentID
        ] as [String: AnyObject]

        doRequest(method: .post, api: .DOCUMENT_DETAIL, params: params, header: [:], success: success, failure: failure)
    }
    
    
    public static func documentInsert(
        title: String,
        content: String,
        label: Int,
        tags: String,
        images: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "title": title,
            "content": content,
            "label": label,
            "tags": tags,
            "images": images,
        ] as [String: AnyObject]

        doRequest(method: .post, api: .DOCUMENT_INSERT, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func documentUpdate(
        id: String,
        title: String,
        content: String,
        label: Int,
        tags: String,
        images: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "id": id,
            "title": title,
            "content": content,
            "label": label,
            "tags": tags,
            "images": images,
        ] as [String: AnyObject]

        doRequest(method: .post, api: .DOCUMENT_UPDATE, params: params, header: [:], success: success, failure: failure)
    }
    
    
    public static func documentDelete(
        id: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "id": id
        ] as [String: AnyObject]

        doRequest(method: .post, api: .DOCUMENT_DELETE, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getAskList(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!
        ] as [String: AnyObject]

        doRequest(method: .post, api: .ASK_LIST, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getNoticeList(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "platform": 1
        ] as [String: AnyObject]

        doRequest(method: .post, api: .GET_NOTICE_LIST, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getNotice(
        noticeID: Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "id": noticeID,
            "access_token": user.access_token!
        ] as [String: AnyObject]

        doRequest(method: .post, api: .GET_NOTICE_DETAIL, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getNotice(
        code: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "id": code,
            "is_code": 1,
            "access_token": user.access_token!
        ] as [String: AnyObject]

        doRequest(method: .post, api: .GET_NOTICE_DETAIL, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getFAQList(
        faqItemId: Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "faq_item_id": faqItemId,
            "platform": 1
        ] as [String: AnyObject]

        doRequest(method: .post, api: .FAQ_LIST, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getFAQCategoryList(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!
        ] as [String: AnyObject]

        doRequest(method: .post, api: .FAQ_CATE, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getVersionInfo(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "platform": 1
        ] as [String: AnyObject]

        doRequest(method: .post, api: .VERSION, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func viewPopup(
        popupId: Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "id": popupId,
            "type": 0
        ] as [String: AnyObject]

        doRequest(method: .post, api: .VIEW_CLICK_POPUP, params: params, header: [:], success: success, failure: failure)
    }

    public static func clickPopup(
        popupId: Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "id": popupId,
            "type": 1
        ] as [String: AnyObject]

        doRequest(method: .post, api: .VIEW_CLICK_POPUP, params: params, header: [:], success: success, failure: failure)
    }

    
    public static func insertAsk(
        title: String,
        content: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
            "title": title,
            "content": content
        ] as [String: AnyObject]

        doRequest(method: .post, api: .INSERT_ASK, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func requestExit(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
        ] as [String: AnyObject]

        doRequest(method: .post, api: .REQUEST_EXIT, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func cancelExit(
        userID: String,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "login_id": userID
        ] as [String: AnyObject]

        doRequest(method: .post, api: .CANCEL_EXIT, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func agreementTerms(
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "access_token": user.access_token!,
        ] as [String: AnyObject]

        doRequest(method: .post, api: .AGREE_TERMS, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getAgreementList(
        isAll: Bool,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        
        var params : [String: AnyObject] = [:]
        
        if !isAll, let user = self.user, let acces_token = user.access_token, !acces_token.isEmpty {
            params["access_token"] = acces_token as AnyObject
        }

        doRequest(method: .post, api: .GET_AGREE_TERMS, params: params, header: [:], success: success, failure: failure)
    }
    
    public static func getAgreementDetail(
        agreeID: Int,
        success: SuccessBlock?,
        failure: FailureBlock?
    ) {
        let params = [
            "id" : agreeID,
        ] as [String: AnyObject]

        doRequest(method: .post, api: .GET_AGREE_DETAIL, params: params, header: [:], success: success, failure: failure)
    }
}
