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

class MusicViewController: UIViewController, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate//, SPTAppRemotePlayerAPI
{
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
    }
    
    
    var delegate: SPTAppRemotePlayerStateDelegate?
    

    var accessToken = ""
    let playUri = ""
    let SpotifyClientID = "a3c4b9c2057a47a69385d0cb1baacb2f"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    var lastPlayerState: SPTAppRemotePlayerState?
    
    var defaultCallback: SPTAppRemoteCallback {
            get {
                return {[weak self] _, error in
                    if let error = error {
                        print(error)
                        
                    }
                }
            }
        }
    


    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )

    lazy var appRemote: SPTAppRemote = {
      let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
      appRemote.connectionParameters.accessToken = self.accessToken
      appRemote.delegate = self
      return appRemote
    }()

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("connected")
        self.appRemote.playerAPI?.delegate = self
            self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            })

    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    
    // required for SPTAppRemotePlayerStateDelegate
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        let track = playerState.track
        print(track.name)
        debugPrint("Track name: %@", playerState.track.name)
    }
    
    
    
    func connect() {
        self.appRemote.authorizeAndPlayURI(self.playUri)
        /*
         Tried establishing a callback so we can pause/skip
         */
        //self.appRemote.playerAPI?.play(self.playUri, asRadio: true, callback: self.defaultCallback)
        // could be this too
        //self.appRemote.playerAPI?.play(self.playUri, callback: self.defaultCallback)
        appRemoteDidEstablishConnection(self.appRemote)
    }
    
    func pause() {
        
        self.appRemote.playerAPI?.pause({(anyOptional, errorOptional) in
            print("Pause working")
        })
        /*
        
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            print("resuming")
            self.appRemote.playerAPI?.resume(defaultCallback)
        }
        else {
            print("pausing")
            self.appRemote.playerAPI?.pause(defaultCallback)
        }
 */
    
        
        /*
         This may work too i just cant test it
         if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            self.appRemote.playerAPI?.resume(nil)
         }
         else {
            self.appRemote.playerAPI?.pause(nil)
         }
         */
        
    }
    
    func skip() {
        //self.appRemote.playerAPI?.skip(toNext:defaultCallback)
        self.appRemote.playerAPI?.pause({(anyOptional, errorOptional) in
            print("skip was successful")
        })
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("working")
    }

    @IBAction func connectButtonPresed(_ sender: Any) {
        print("connecting")
        connect()
    }
    
    // pause not working
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        print("play/pause pressed")
        pause()
    }
    
    // skip not working
    @IBAction func skipPressed(_ sender: Any) {
        print("skip pressed")
        skip()
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}"
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

