//
//  SpotifyLoginViewController.swift
//  passionProject
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SafariServices

class SpotifyLoginViewController: UIViewController {
    //should be our iOS app scheme
    private let scheme = "passionProject://"
    
    //class that manages sharing a one-time web-service login, along with cookies and website data between safari and the app; which can be used for automatic log in
    //here we are making sure we have a strong reference to the session
    //read more about this on apple documentation
    private var authSession: SFAuthenticationSession? //this will help you login with the keys
    //provides you the webview and the alert
    
    private let tokenAPI = TokenAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //this helper function will help us retrieve the code from the callback url (basically separate the code from the scheme)
    private func getParam(url: URL, param: String) -> String? {
        guard let urlComponents = URLComponents(string: url.absoluteString) else {
            print("url is nil")
            return nil
        }
        //gets the first element of the sequence that satisties the given predicate
        return urlComponents.queryItems?.first{$0.name == param}?.value //gets the first param that has the name you want, and then gives you its value
    }
    
    @IBAction func spotifyLogin(_ sender: UIButton) {
        //Here we are creating a SFAuthenticationSession to present the user with a login page of the web service e.g Spotify login page
        //scheme is the redirect uri
        //instantiate the authsession here with the auth URL (provided by the service), our iOS App Scheme
        authSession = SFAuthenticationSession(url: URL(string: SpotifyKeys.authURL)!, callbackURLScheme: scheme, completionHandler: { (callbackURL, error) in
            if let error = error {
                print("loginWithSpotify error: \(error)")
            } else if let callbackURL = callbackURL {
                print("callbackURL: \(callbackURL)")
                //handshake 1 - get authorization code
                guard let authorizationCode = self.getParam(url: callbackURL, param: "code") else {
                    print("need valid authorization code")
                    return
                }
                print(authorizationCode)
                //handshake 2 - get access token
                self.tokenAPI.tokenExchange(code: authorizationCode)
            }
        })
        authSession?.start()
    }
    
    

}
