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
    //MEDIUM
    var player: SPTAudioStreamingController?
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var loginUrl: URL? //NOT SURE IF I NEED THIS DELETE THIS MAYBE
   
    //class that manages sharing a one-time web-service login, along with cookies and website data between safari and the app; which can be used for automatic log in
    //here we are making sure we have a strong reference to the session
    //read more about this on apple documentation
   // private var authSession: SFAuthenticationSession? //this will help you login with the keys
    //provides you the webview and the alert
    
    //private let tokenAPI = TokenAPI()
    
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
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    //this helper function will help us retrieve the code from the callback url (basically separate the code from the scheme)
//    private func getParam(url: URL, param: String) -> String? {
//        guard let urlComponents = URLComponents(string: url.absoluteString) else {
//            print("url is nil")
//            return nil
//        }
        //gets the first element of the sequence that satisties the given predicate
//        return urlComponents.queryItems?.first{$0.name == param}?.value //gets the first param that has the name you want, and then gives you its value
//    }
//
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }

    
    @IBAction func spotifyLogin(_ sender: UIButton) {
        //Here we are creating a SFAuthenticationSession to present the user with a login page of the web service e.g Spotify login page
        //scheme is the redirect uri
        //instantiate the authsession here with the auth URL (provided by the service), our iOS App Scheme
//        authSession = SFAuthenticationSession(url: URL(string: SpotifyKeys.authURL)!, callbackURLScheme: scheme, completionHandler: { (callbackURL, error) in
//            if let error = error {
//                print("loginWithSpotify error: \(error)")
//            } else if let callbackURL = callbackURL {
//                print("callbackURL: \(callbackURL)")
//                //handshake 1 - get authorization code
//                guard let authorizationCode = self.getParam(url: callbackURL, param: "code") else {
//                    print("need valid authorization code")
//                    return
//                }
//                print(authorizationCode)
//                //handshake 2 - get access token
//                self.tokenAPI.tokenExchange(code: authorizationCode)
//            }
//        })
//        authSession?.start()
        UIApplication.shared.open(loginUrl!, options: [:]) { (success) in
            if success {
                if self.auth.canHandle(self.auth.redirectURL) {
                    //                //to do -build in error handling
                  
            }
        }
        
        }
    }
    
    

}
