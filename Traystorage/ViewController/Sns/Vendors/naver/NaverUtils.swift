//
//  NaverUtils.swift
//  GetSome
//
//  Created by pjh on 9/25/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import Foundation
import AEXML
import NaverThirdPartyLogin

protocol NaverUtilsDelegate: class  {
    func NaverSign(info: NaverUserInfo)
    func NaverSignError()
}

class NaverUtils : NSObject {

    var fromVC : UIViewController!
    var delegate : NaverUtilsDelegate!
    
    public init(_ vc:UIViewController?) {
        self.fromVC = vc
    }
    
    public func getNaverInfo() {
        
        let tlogin : NaverThirdPartyLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        tlogin.delegate = self
        tlogin.consumerKey = kConsumerKey
        tlogin.consumerSecret = kConsumerSecret
        tlogin.serviceUrlScheme = kServiceAppUrlScheme
        tlogin.appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String // 앱이름
        tlogin.requestThirdPartyLogin()
    }
    
    public func logout() {
        let tlogin : NaverThirdPartyLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        tlogin.delegate = self
        tlogin.requestDeleteToken()
    }
}
extension NaverUtils : NaverThirdPartyLoginConnectionDelegate {
    
    func parRseXML(_ str: String) {
        do {
            let xmlDoc = try AEXMLDocument(xml: str)
            if (xmlDoc.root["result"]["resultcode"].string == "00") {
                
                let naverInfo = NaverUserInfo()
                naverInfo.id = xmlDoc.root["response"]["id"].string
                naverInfo.email = xmlDoc.root["response"]["email"].string
                naverInfo.name = xmlDoc.root["response"]["name"].string
                naverInfo.profile_img_url = xmlDoc.root["response"]["profile_image"].string
                naverInfo.birthday = xmlDoc.root["response"]["birtyday"].string.replacingOccurrences(of: "-", with: "")
                
                if(delegate != nil){
                    delegate?.NaverSign(info: naverInfo)
                }
                
            } else {
                if(delegate != nil){
                    delegate?.NaverSignError()
                }
                
            }
        }
        catch {
            if(delegate != nil){
                delegate?.NaverSignError()
            }
        }
    }
    
    func naverSDKDidLoginSuccess() {
        /* 네이버 회원 정보 조회 */
        let loginConn = NaverThirdPartyLoginConnection.getSharedInstance()
        let tokenType = loginConn?.tokenType
        let accessToken = loginConn?.accessToken
        
        // Get User Profile
        if let url = URL(string: "https://apis.naver.com/nidlogin/nid/getUserProfile.xml") {
            if tokenType != nil && accessToken != nil {
                let authorization = "\(tokenType!) \(accessToken!)"
                var request = URLRequest(url: url)
                request.setValue(authorization, forHTTPHeaderField: "Authorization")
                let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
                    if let str = String(data: data!, encoding: .utf8) {
                        print(str)
                        //loginConn?.resetToken()
                        //loginConn?.removeNaverLoginCookie()
                        
                        DispatchQueue.main.async {
                            self.parRseXML(str)
                        }
                    }
                    else {
                        if(self.delegate != nil){
                            self.delegate?.NaverSignError()
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // 로그인이 성공했을 경우 호출
        naverSDKDidLoginSuccess()
        //        g_ProgressUtil.hideProgress()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        /* 로그인 실패시에 호출되며 실패 이유와 메시지 확인 가능합니다. */
        print("oauth20Connection")
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 이미 로그인이 되어있는 경우 access 토큰을 업데이트 하는 경우
        print("oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        naverSDKDidLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        // 로그아웃이나 토큰이 삭제되는 경우
        print("oauth20ConnectionDidFinishDeleteToken")
    }
}
