//
//  SceneDelegate.swift
//  Traystorage
//
//  Created by Star_Man on 1/5/22.
//

import Firebase
import FirebaseDynamicLinks
import NaverThirdPartyLogin
import UIKit
import GoogleSignIn
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            let urlStr = url.absoluteString
            print(urlStr)

//            if urlStr.contains(self.SCHEME + "://") {
//                self.showRecvData(recv: URLContexts)
//                return
//            }
//
            if urlStr.contains("traystorage://") { // naver
                NaverThirdPartyLoginConnection
                    .getSharedInstance()?
                    .receiveAccessToken(URLContexts.first?.url)
                return
            }

            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, _ in

                // dynamic link 처리
                print(dynamicLink?.url?.absoluteString as Any)
                let link = dynamicLink?.url?.absoluteString
                if link == nil || link == "" {
                    return
                }
                if link!.contains("https://traystorageen.page.link") {
                    print(link as Any)
                    Local.setDimLink(link!)
                    NotificationCenter.default.post(name: NSNotification.Name("dimlink"), object: nil)
                }
            }
        }
    }
}
