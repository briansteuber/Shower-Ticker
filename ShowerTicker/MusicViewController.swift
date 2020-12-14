//
//  MusicViewController.swift
//  Shower Ticker
//  Brian Steuber and Tyler Gonzalez
//  Final Project
//
//  Created by Nancy Gonzalez on 11/27/20.
//

import UIKit

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
    //var defaultCallback: SPTAppRemoteCallback
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
        //self.appRemote.authorizeAndPlayURI(self.playUri)
        /*
         Tried establishing a callback so we can pause/skip
         */
        self.appRemote.playerAPI?.play(self.playUri, asRadio: true, callback: self.defaultCallback)
        appRemoteDidEstablishConnection(self.appRemote)
    }
    
    func pause() {
        self.appRemote.playerAPI?.resume(defaultCallback)
        
        
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
        self.appRemote.playerAPI?.skip(toNext:
            defaultCallback)
        
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
        self.pause()
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
}
