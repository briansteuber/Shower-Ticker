//
//  MusicViewController.swift
//  Shower Ticker
//  Brian Steuber and Tyler Gonzalez
//  Final Project
//
//  Created by Nancy Gonzalez on 11/27/20.
//

import UIKit

class MusicViewController: UIViewController
{
    
    var isPlaying = true
    
    var appRemote: SPTAppRemote? {
            get {
                return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appRemote
            }
        }
    
    var index = -1
    

    static private let kAccessTokenKey = "access-token-key"
    // can maybe be empty ?? idk
    let playUris = ""// ["spotify:track:20I6sIOMTCkB6w7ryavxtO", "spotify:track:6Knv6wdA0luoMUuuoYi2i1"]
    
    let SpotifyClientID = "a3c4b9c2057a47a69385d0cb1baacb2f"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    var lastPlayerState: SPTAppRemotePlayerState?
    
   
    
    
    
    
    
    
    func connect() {
//        if !(appRemote?.isConnected ?? false) {
 //                  appRemote?.connect()
 //              }
        self.appRemote?.authorizeAndPlayURI(self.playUris)
        /*
         Tried establishing a callback so we can pause/skip
         */
        //self.appRemote.playerAPI?.play(self.playUri, asRadio: true, callback: self.defaultCallback)
        // could be this too
        //self.appRemote.playerAPI?.play(self.playUri, callback: self.defaultCallback)
        //appRemoteDidEstablishConnection(self.appRemote)
    }
    
    func pause() {
       /*
        index += 1
                index %= playUris.count
                let playUri = playUris[index]
                if !(appRemote?.isConnected ?? false) {
                    print("app remote is not connected")
                    appRemote?.authorizeAndPlayURI(playUri)
                }
                else {
                    print("app remote is connected")
                    appRemote?.playerAPI?.play(playUri, callback: { (anyOptional, errorOptional) in
                        print("successfully playing...")
                    })
                }
 */
        //self.appRemote.playerAPI?.pause({(any, errorOptional) in
            //print("Pause working")
        //})
    
        if isPlaying == true {
            print("pausing")
            self.appRemote?.playerAPI?.pause({(anyOptional, errorOptional) in
                print("pause was successful")
            })
            isPlaying = !isPlaying
        }
        else {
            print("resuming")
            self.appRemote?.playerAPI?.resume({(anyOptional, errorOptional) in
                print("resume was successful")
            })
            isPlaying = !isPlaying
        }
        
        /*
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            print("resuming")
            self.appRemote?.playerAPI?.resume({(anyOptional, errorOptional) in
                print("resume was successful")
            })
        }
        else {
            print("pausing")
            self.appRemote?.playerAPI?.pause({(anyOptional, errorOptional) in
                print("pause was successful")
            })
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
       /*
         self.appRemote?.playerAPI?.pause({(anyOptional, errorOptional) in
            print("pause was successful")
        })
 */
        
    }
    
    func skip() {
        self.appRemote?.playerAPI?.skip(toNext: {(anyOptional, errorOptional) in
            print("skip was successful")
        })
      //  self.appRemote?.playerAPI?.pause({(anyOptional, errorOptional) in
       //     print("skip was successful")
    //    })
        
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
