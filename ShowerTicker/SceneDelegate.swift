//
//  SceneDelegate.swift
//  ShowerTicker
//
//  Created by Steuber, Brian William on 12/5/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SPTAppRemoteDelegate {
    
    var MusicViewController: MusicViewController {
        get {
            let tabBarController = window?.rootViewController as! UITabBarController
            return tabBarController.viewControllers![2] as! MusicViewController
                }
    }
    

    
    static private let kAccessTokenKey = "access-token-key"
        let clientIdentifier = "a3c4b9c2057a47a69385d0cb1baacb2f"

        let redirectUri = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

        var window: UIWindow?
        
        
        lazy var appRemote: SPTAppRemote = {
            let configuration = SPTConfiguration(clientID: self.clientIdentifier, redirectURL: self.redirectUri)
            let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
            appRemote.connectionParameters.accessToken = self.accessToken
            appRemote.delegate = self
            return appRemote
        }()

        var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
            didSet {
                let defaults = UserDefaults.standard
                defaults.set(accessToken, forKey: SceneDelegate.kAccessTokenKey)
            }
        }

        func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
            self.appRemote = appRemote
        }
        
        func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
            print("didFailConnectionAttemptWithError")
        }
        
        func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
            print("didDisconnectWithError")
        }

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
            // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
            // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
            guard let _ = (scene as? UIWindowScene) else { return }

        }
        
        // GS: adding for Spotify
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            guard let url = URLContexts.first?.url else {
                return
            }

            let parameters = appRemote.authorizationParameters(from: url);

            if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
                appRemote.connectionParameters.accessToken = access_token
                self.accessToken = access_token
            } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
                print("~~~~\(errorDescription)")
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
            appRemote.connect()
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
    
}

