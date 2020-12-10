//
//  MusicViewController.swift
//  Shower Ticker
//  Brian Steuber and Tyler Gonzalez
//  Final Project
//
//  Created by Nancy Gonzalez on 11/27/20.
//

import UIKit

class MusicViewController: UIViewController, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate // may want to use SPTAppRemotePlayerAPI???
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
        appRemoteDidEstablishConnection(self.appRemote)
    }
    
    func pause() {
        self.appRemote.playerAPI?.pause(nil)

    }
    
    func skip() {
        self.appRemote.playerAPI?.skip(toNext: nil)
        
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
}
