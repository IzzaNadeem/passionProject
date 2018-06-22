//
//  SpotifyKeys.swift
//  passionProject
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
//OAuth specs are standardized
//overall, OAuth users will have:
//clientID
//clientSecret
//we should provide a redirect URI (Unified Resource Identifier) - the page the user will be redirected to
//URL is under URI, an umbrella term
struct SpotifyKeys {
    private static let clientID = "87651b0a4fc34e36ac8cea0b9cd0e96a" //appID, this is generated
    private static let clientSecret = "1b23a45305504046b1a33abda0279935"
    
    //This redirect_uri is responsible for attaching the authorization code and redirecting to your app for the token exhange process.
    private static let redirectURI = "passionProject://returnAfterLogin" //sometimes this could be provided by the service (others might not do this), sometimes - we're using a custom URI, but we can also do an https; sometimes could be the name of your app
    //instagram, facebook, strava, etc. doesn't let you do this
    //if its an https, you need to have a server to do this
    //ideally you generate a uid, and this number should be the same coming back from the service
    private static let state = "23978971823775" //a code that acts kind of like a pairing key between the app and the client
    private static let scope = "" //worry about this later
    
    //The authorization process starts with your application sending a request to the Spotify Accounts service
    //The request is sent to the /authorize endpoint of the Accounts service
    public static let authURL = "https://accounts.spotify.com/authorize/?client_id=\(SpotifyKeys.clientID)&response_type=code&redirect_uri=\(SpotifyKeys.redirectURI)&state=\(SpotifyKeys.state)" //we need this to give the session
    //the http used to exchange the authCode for the token
    public static let tokenExchangeURL = "https://accounts.spotify.com/api/token?"
    
    //required parameters for making post request for token exchange
    //grant type
    //redirect uri
    //code - received from initial authorization request
    //client_id
    //client_secret - instead of putting it in the authorization header
    //headers:
    //Accept: application/json
    //Content-Type: application/x-www-form-urlencoded
    public static let httpBody = "grant_type=authorization_code&redirect_uri=\(SpotifyKeys.redirectURI)&client_id=\(SpotifyKeys.clientID)&client_secret=\(SpotifyKeys.clientSecret)&code="
}
