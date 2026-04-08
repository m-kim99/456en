//
//  KakaotalkUtils.swift
//  Log
//
//  Created by Point on 10/28/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

class KakaotalkUtils {
    public static func getKakaotalkInfo(from_vc: UIViewController, callback: @escaping (_ userInfo: KakaotalkUserInfo) -> Void, error_callback: @escaping (_ error: Error) -> Void) {
        let session = KOSession.shared()!
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = from_vc
        session.open { error in
            if error != nil {
                // MsgUtil.showUIAlert((error?.localizedDescription)!)
                print(error?.localizedDescription as Any)
                error_callback(error!)
            } else if session.isOpen() == true {
                KOSessionTask.userMeTask(completion: { (error, profile) -> Void in
          
//          session.logoutAndClose(completionHandler: nil)
          
                    if profile != nil {
                        DispatchQueue.main.async { () -> Void in
                            let kakao = profile
              
                            if kakao == nil {
                                let error = NSError(domain: "noInfo", code: 0)
                                error_callback(error)
                                return
                            }
              
                            let kakaoInfo = KakaotalkUserInfo()
                            kakaoInfo.id = kakao?.id ?? ""
                            kakaoInfo.email = kakao?.account?.email ?? ""
                            kakaoInfo.name = (kakao?.nickname) ?? ""
                            kakaoInfo.profile_img_url = (kakao?.profileImageURL?.absoluteString) ?? ""
                            kakaoInfo.birthday = (kakao?.account?.birthday) ?? ""
              
                            callback(kakaoInfo)
                        }
                    } else {
                        // MsgUtil.showUIAlert("카카오톡 정보를 불러오는데 실패했습니다.")
                        error_callback(error!)
                    }
                })
            } else {
                error_callback(error!)
            }
        }
    }
    
    public static func logout() {
           let session = KOSession.shared()
           session?.logoutAndClose(completionHandler: { success, error in
               if success {
                   print("logout success.")
               } else {
                   print(error?.localizedDescription)
               }
           })
       }
}
