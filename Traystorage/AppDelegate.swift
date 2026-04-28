//
//  AppDelegate.swift
//  Traystorage
//
//  Created by Star_Man on 1/5/22.
//
import Firebase
import UIKit
import NaverThirdPartyLogin
import GoogleSignIn
import FirebaseDynamicLinks
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let thirdConn: NaverThirdPartyLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        thirdConn.isNaverAppOauthEnable = false
        thirdConn.isInAppOauthEnable = true
        thirdConn.setOnlyPortraitSupportInIphone(true)
        thirdConn.serviceUrlScheme = kServiceAppUrlScheme
        thirdConn.consumerKey = kConsumerKey
        thirdConn.consumerSecret = kConsumerSecret
        thirdConn.setOnlyPortraitSupportInIphone(true)
        
        FirebaseApp.configure()
        
        // Kakao SDK 초기화
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let _ = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            return true
        }
        
        // kakao
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // kakao
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        // 네이버 로그인 처리
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        // Google Sign In 처리
        return GIDSignIn.sharedInstance.handle(url)
    }
       
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        // kakao
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
       
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("1. Message ID: \(messageID)")
        }
        print(userInfo)
    }
       
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("2. Message ID: \(messageID)")
        }
        print(userInfo)
           
        if application.applicationState == .active {
            print("active state")
        } else if application.applicationState == .background {
            print("background state")
        } else if application.applicationState == .inactive {
            print("inactive state")
        }
           
        completionHandler(UIBackgroundFetchResult.newData)
    }
       
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
       
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
                if error != nil {
                    print(error as Any)
                }
                print(dynamiclink as Any)
            }

        return handled
    }
}
