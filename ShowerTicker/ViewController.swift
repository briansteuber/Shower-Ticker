//
//  ViewController.swift
//  ShowerTicker
//
//  Created by Steuber, Brian William on 12/5/20.
//

import UIKit

class ViewController: UIViewController, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {

        var accessToken = ""
        
        let SpotifyClientID = "0df5f078d56e4fe9920fae2826a33da0"
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
        }
        func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
          print("disconnected")
        }
        func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
          print("failed")
        }
        func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
          print("player state changed")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let playUri = "spotify:track:20I6sIOMTCkB6w7ryavxtO"
        self.appRemote.authorizeAndPlayURI(playUri)
        print("working")
    }


}


