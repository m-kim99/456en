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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let thirdConn: NaverThirdPartyLoginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        thirdConn.isNaverAppOauthEnable = true
        thirdConn.isInAppOauthEnable = true
        thirdConn.setOnlyPortraitSupportInIphone(true)
        thirdConn.serviceUrlScheme = kServiceAppUrlScheme
        thirdConn.consumerKey = kConsumerKey
        thirdConn.consumerSecret = kConsumerSecret
        thirdConn.setOnlyPortraitSupportInIphone(true)
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            return true
        }
        
        // kakao
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // kakao
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        return GIDSignIn.sharedInstance.handle(url)
    }
       
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        // kakao
        if KOSession.isKakaoAccountLoginCallback(url as URL) {
            return KOSession.handleOpen(url as URL)
        }
        return false
    }
       
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive()
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
                    print(error)
                }
                print(dynamiclink)
            }

        return handled
    }
}
