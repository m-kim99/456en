//
//  GoogleUtils.swift
//  GetSome
//
//  Created by pjh on 9/25/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import Foundation
import GoogleSignIn
import GTMAppAuth

protocol GoogleUtilsDelegate: class {
  func GoogleSign(info: GoogleUserInfo)
  func GoogleSignError()
}

class GoogleUtils: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
  var fromVC: UIViewController!
  var delegate: GoogleUtilsDelegate!
  var googleInfo = GoogleUserInfo()
  var authorizer: GTMAppAuthFetcherAuthorization?
  
  public init(_ vc: UIViewController?) {
    fromVC = vc
  }
  
  public func GoogleSignIn() {
    if true {
      GIDSignIn.sharedInstance().delegate = self
      GIDSignIn.sharedInstance().uiDelegate = self
      GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
      GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
      GIDSignIn.sharedInstance().signIn()
    }
    else {
      // requestOAuth()
    }
  }
  
  // MARK: GIDSignIn Delgate
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    if error != nil {
      if delegate != nil {
        delegate?.GoogleSignError()
      }
      return
    }
    
    signIn.signOut()
    
    googleInfo.id = user.userID!
    googleInfo.email = user.profile.email
    googleInfo.name = user.profile.name
    googleInfo.profile_img_url = user.profile.imageURL(withDimension: 400)?.absoluteString ?? ""
    googleInfo.birthday = ""
    
    if delegate != nil {
      delegate?.GoogleSign(info: googleInfo)
    }
  }
    
    func logout()  {
        //
    }
  
  /*    func requestOAuth() {
       let issuer = "https://accounts.google.com"
       let redirectUrl = GOOGLE_SCHEMA + ":/oauthredirect"//"urn:ietf:wg:oauth:2.0:oob"
       let issuerUrl = URL(string: issuer)
       OIDAuthorizationService.discoverConfiguration(forIssuer: issuerUrl!) { (configure, error) in
           if(configure == nil) {
               if(self.delegate != nil){
                   self.delegate?.GoogleSign(info: self.googleInfo)
               }
               return
           }
   
           let request = OIDAuthorizationRequest(configuration: configure!, clientId: GOOGLEKEY, clientSecret: "etaA_vM_JCzjE9RL1CRR4-vR", scopes: [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail], redirectURL: URL(string:redirectUrl)!, responseType: OIDResponseTypeCode, additionalParameters: [:])
   
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           appDelegate.googleAuthFlow = OIDAuthState.authState(byPresenting: request, presenting: self.fromVC, callback: { (state, error) in
               if(state != nil) {
                   self.authorizer = GTMAppAuthFetcherAuthorization(authState: state!)
                   self.googleInfo.id = self.authorizer!.userID!
                   self.googleInfo.email = self.authorizer!.userEmail!
   
                   let service = GTLRPeopleServiceService()
                   let getDataQuery:GTLRPeopleServiceQuery_PeopleGet =  GTLRPeopleServiceQuery_PeopleGet.query(withResourceName: "people/me")
                   getDataQuery.personFields = "names,genders"
                   service.apiKey = GOOGLE_API_KEY
                   service.authorizer = self.authorizer!
   
                   service.executeQuery(getDataQuery, delegate: self, didFinish: #selector(self.getCreatorFromTicket(ticket:finishedWithObject:error:)))
               }
               else {
                   if(self.delegate != nil){
                       self.delegate?.GoogleSign(info: self.googleInfo)
                   }
               }
           })
       }
   }
   
   @objc func getCreatorFromTicket(
       ticket: GTLRServiceTicket,
       finishedWithObject response: GTLRPeopleService_Person,
       error: NSError?) {
       if error != nil {
           if(self.delegate != nil){
               self.delegate?.GoogleSign(info: googleInfo)
           }
           return
       }
   
       if let names = response.names, !names.isEmpty {
           for name in names {
               if name.displayName != nil {
                   googleInfo.name = name.displayName!
                   break
               }
           }
       }
   
       if let genders = response.genders, !genders.isEmpty {
           for gender in genders {
               if gender.value != nil {
                   googleInfo.gender = gender.value!
                   break
               }
           }
       }
   
       if(self.delegate != nil){
           self.delegate?.GoogleSign(info: googleInfo)
       }
   }*/
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    if delegate != nil {
      delegate?.GoogleSignError()
    }
  }
  
  func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
    // viewController.dismiss(animated: true, completion: nil)
  }
  
  func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
    fromVC.present(viewController, animated: true, completion: nil)
  }
}
