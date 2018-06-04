//
//  SpotifyLoginViewController.swift
//  passionProject
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class SpotifyLoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    //should be our iOS app scheme
    private let scheme = "passionProject://"
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var coverImage: UIImageView!
    
    var player: SPTAudioStreamingController?
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var loginUrl: URL? //URL used to go to the web to loginto spotify you give it value in setup func
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //MEDIUM ARTICLE
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyLoginViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)

    }
    
    func initializaPlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            
        }
    }
    //MEDIUM ARTICLE
    @objc func updateAfterFirstLogin() {
        loginButton.isHidden = true
//        coverImage.image = UIImage(named: "imagecover.jpg")
        coverImage.image = #imageLiteral(resourceName: "imagecover.jpg")
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializaPlayer(authSession: session)
        }
    }

    
    //MEDIUM ARTICLE
    func setup() {
        SPTAuth.defaultInstance().clientID = "87651b0a4fc34e36ac8cea0b9cd0e96a"
        SPTAuth.defaultInstance().redirectURL = URL(string: "passionProject://returnAfterLogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistReadPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL() //URL used to go to the web to loginto spotify
    }
  
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        //look into AVAFoundation //iOS 11h
        self.player?.playSpotifyURI("spotify:track:77a5Eu7lC3tG0Sukt2O91U?context=spotify%3Auser%3Aspotify%3Aplaylist%3A37i9dQZF1DX1lVhptIYRda", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }

    
    @IBAction func spotifyLogin(_ sender: UIButton) {
        UIApplication.shared.open(loginUrl!, options: [:]) { (success) in
            if success {
                if self.auth.canHandle(self.auth.redirectURL) {
                    //                //to do -build in error handling
                  
            }
        }
        
        }
    }
    
    

}
