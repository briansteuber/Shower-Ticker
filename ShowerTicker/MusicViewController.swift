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
    let playUris = ""
    
    var appRemote: SPTAppRemote? {
            get {
                return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appRemote
            }
        }

    func connect() {
        self.appRemote?.authorizeAndPlayURI(self.playUris)
    }
    
    func playOrPause() {
        if isPlaying == true {
            print("pausing")
            pause()
            isPlaying = !isPlaying
        }
        else {
            print("resuming")
            play()
            isPlaying = !isPlaying
        }
    }
    
    func pause() {
        self.appRemote?.playerAPI?.pause({(anyOptional, errorOptional) in
            print("pause was successful")
        })
    }
    
    func play() {
        self.appRemote?.playerAPI?.resume({(anyOptional, errorOptional) in
            print("resume was successful")
        })
    }
    
    func skip() {
        self.appRemote?.playerAPI?.skip(toNext: {(anyOptional, errorOptional) in
            print("skip was successful")
        })
        isPlaying = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("working")
    }

    @IBAction func connectButtonPresed(_ sender: Any) {
        print("connecting")
        isPlaying = true
        connect()
    }
    
    // pause not working
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        print("play/pause pressed")
        playOrPause()
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
