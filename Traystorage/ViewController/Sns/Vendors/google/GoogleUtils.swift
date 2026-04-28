//
//  GoogleUtils.swift
//  GetSome
//
//  Created by pjh on 9/25/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import Foundation
import GoogleSignIn

protocol GoogleUtilsDelegate: AnyObject {
  func GoogleSign(info: GoogleUserInfo)
  func GoogleSignError()
}

class GoogleUtils: NSObject {
  var fromVC: UIViewController!
  weak var delegate: GoogleUtilsDelegate?
  var googleInfo = GoogleUserInfo()
  
  public init(_ vc: UIViewController?) {
    fromVC = vc
  }
  
  public func googleSignIn() {
    GIDSignIn.sharedInstance.signIn(withPresenting: fromVC) { [weak self] result, error in
      guard let self = self else { return }
      
      if error != nil {
        self.delegate?.GoogleSignError()
        return
      }
      
      guard let user = result?.user else {
        self.delegate?.GoogleSignError()
        return
      }
      
      GIDSignIn.sharedInstance.signOut()
      
      self.googleInfo.id = user.userID ?? ""
      self.googleInfo.email = user.profile?.email ?? ""
      self.googleInfo.name = user.profile?.name ?? ""
      self.googleInfo.profile_img_url = user.profile?.imageURL(withDimension: 400)?.absoluteString ?? ""
      self.googleInfo.birthday = ""
      
      self.delegate?.GoogleSign(info: self.googleInfo)
    }
  }
    
  func logout() {
    GIDSignIn.sharedInstance.signOut()
  }
}
