//
//  SnsManager.swift
//  Log
//
//  Created by Point on 10/28/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

protocol SnsManagerDelegate {
    func snsAuthCompleted(_ me: SnsUserInfo)
    func snsAuthError(_ type: SnsType, msg: String)
}

class SnsManager {
    private var mViewController: UIViewController?
    private var mSnsUserInfo = SnsUserInfo()
    private var mNaverUtil: NaverUtils
    public var delegate: SnsManagerDelegate?
//    private var mGoogleUtil: GoogleUtils
    
    public init(_ vc: UIViewController?) {
        self.mViewController = vc
        self.mNaverUtil = NaverUtils(mViewController)
//        self.mGoogleUtil = GoogleUtils(mViewController)
//        self.mGoogleUtil = GoogleSignInAuthenticator(authViewModel: mViewController!.self)
    }
    
    public func getSnsGender(gender: String?) -> SnsGenderType {
        var strGender = ""
        if gender != nil {
            strGender = gender!.lowercased()
        }
        
        // 성별을 얻지 못했을 경우 여자로 처리함
        var result: SnsGenderType = .Woman
        if strGender.isEmpty == false {
            if strGender == "man" || strGender == "m" || strGender == "male" {
                result = .Man
            } else if strGender == "girl" || strGender == "woman" || strGender == "fmale" || strGender == "w" || strGender == "f" || strGender == "g" {
                result = .Woman
            }
            
            return result
        }
        
        return result
    }
    
    public func start(type: SnsType) {
        if type == .Kakao {
            KakaotalkUtils.getKakaotalkInfo(from_vc: mViewController!, callback: { userInfo in
                
                self.mSnsUserInfo.user_name = userInfo.name
                gMeInfo.user_sns_id = userInfo.id
                gMeInfo.user_name = userInfo.name
                gMeInfo.user_email = userInfo.email
                gMeInfo.user_photo_url = userInfo.profile_img_url
                gMeInfo.user_birth = userInfo.birthday
                gMeInfo.user_login_type = .Kakao
                
                self.requestLogin()
            }) { _ in
                self.delegate?.snsAuthError(type, msg: "카카오톡정보를 얻어올수 없습니다.")
            }
        } else if type == .Naver {
            mNaverUtil.delegate = self
            mNaverUtil.getNaverInfo()
        } else if type == .Google {
//            mGoogleUtil.delegate = self
//            mGoogleUtil.GoogleSignIn()
        }
    }
    
    public func logout() {
        switch gMeInfo.user_login_type {
        case .Kakao?:
            KakaotalkUtils.logout()
        case .Naver?:
            mNaverUtil.logout()
        case .Google?:
            // mGoogleUtil.logout()
            mNaverUtil.logout()
        case .Facebook?:
            print("facebook null")
            // default:
        // sns_type_str = "Unknown"
        case .none:
            print("no Unknown")
        }
    }
    
    private func requestLogin() {
        // 로그인 연동 or 회원가입
        
        print(gMeInfo)
        
        var sns_type_str = "이메일"
        switch gMeInfo.user_login_type {
        case .Kakao?:
            sns_type_str = "카카오"
        case .Naver?:
            sns_type_str = "네이버"
        case .Google?:
            sns_type_str = "구글"
        case .Facebook?:
            sns_type_str = "페이스북"
        default:
            sns_type_str = "Unknown"
        }
        var printStr = "로그인유형: " + sns_type_str + "\n"
        printStr += "sns_id: " + gMeInfo.user_sns_id + "\n"
        printStr += "email: " + gMeInfo.user_email + "\n"
        printStr += "name: " + gMeInfo.user_name + "\n"
        printStr += "prifile_img_url: " + gMeInfo.user_photo_url + "\n"
        printStr += "birthday(MMDD): " + gMeInfo.user_birth
        
        print(printStr)
        
        delegate?.snsAuthCompleted(gMeInfo)
    }
}

extension SnsManager: NaverUtilsDelegate {
    func NaverSign(info userInfo: NaverUserInfo) {
        gMeInfo.user_sns_id = userInfo.id
        gMeInfo.user_name = userInfo.name
        gMeInfo.user_email = userInfo.email == "" ? userInfo.id + "@naver.sns" : userInfo.email
        gMeInfo.user_photo_url = userInfo.profile_img_url
        gMeInfo.user_birth = userInfo.birthday
        gMeInfo.user_login_type = .Naver
    
        requestLogin()
    }
  
    func NaverSignError() {
        delegate?.snsAuthError(.Naver, msg: "네이버정보를 얻어올수 없습니다.")
    }
}

/*
 extension SnsManager: GoogleUtilsDelegate {
   func GoogleSign(info userInfo: GoogleUserInfo) {
       gMeInfo.user_sns_id = userInfo.id
       gMeInfo.user_name = userInfo.name
       gMeInfo.user_email = userInfo.email == "" ? userInfo.id + "@google.sns" : userInfo.email
       gMeInfo.user_photo_url = userInfo.profile_img_url
       gMeInfo.user_birth = userInfo.birthday
       gMeInfo.user_login_type = .Google
    
     requestLogin()
   }
  
   func GoogleSignError() {
     delegate?.snsAuthError(.Google, msg: "구글정보를 얻어올수 없습니다.")
   }
 }
 */
