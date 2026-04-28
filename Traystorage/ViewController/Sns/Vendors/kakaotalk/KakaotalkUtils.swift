//
//  KakaotalkUtils.swift
//  Log
//
//  Created by Point on 10/28/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

class KakaotalkUtils {
    public static func getKakaotalkInfo(from_vc: UIViewController, callback: @escaping (_ userInfo: KakaotalkUserInfo) -> Void, error_callback: @escaping (_ error: Error) -> Void) {
        
        let loginCompletion: (OAuthToken?, Error?) -> Void = { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                error_callback(error)
                return
            }
            
            UserApi.shared.me { (user, error) in
                if let error = error {
                    error_callback(error)
                    return
                }
                
                guard let user = user else {
                    let error = NSError(domain: "noInfo", code: 0)
                    error_callback(error)
                    return
                }
                
                DispatchQueue.main.async {
                    let kakaoInfo = KakaotalkUserInfo()
                    kakaoInfo.id = "\(user.id ?? 0)"
                    kakaoInfo.email = user.kakaoAccount?.email ?? ""
                    kakaoInfo.name = user.kakaoAccount?.profile?.nickname ?? ""
                    kakaoInfo.profile_img_url = user.kakaoAccount?.profile?.profileImageUrl?.absoluteString ?? ""
                    kakaoInfo.birthday = user.kakaoAccount?.birthday ?? ""
                    
                    callback(kakaoInfo)
                }
            }
        }
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(completion: loginCompletion)
        } else {
            UserApi.shared.loginWithKakaoAccount(completion: loginCompletion)
        }
    }
    
    public static func logout() {
        UserApi.shared.logout { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("logout success.")
            }
        }
    }
}
