//
//  TokenAPI.swift
//  passionProject
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

//makes api call to spotify
class TokenAPI {
    public func tokenExchange(code: String) {
        var urlRequest = URLRequest(url: URL(string:"\(SpotifyKeys.tokenExchangeURL)")!)
        urlRequest.httpMethod = "POST"
        
        //set headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //set body
        urlRequest.httpBody = "\(SpotifyKeys.httpBody)\(code)".data(using: .utf8)!
        
        NetworkSession.shared.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                print("token exchange error: \(error)")
                //should restart the whole process here again when token expires
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let token = try decoder.decode(SpotifyToken.self, from: data)
                    print("token: \(token)")
                    //save this token to user defaults until it expires
                    //when it does expire, it'll trigger the error block, and you'll need to refresh the token
                } catch {
                    print("token exchange decoding error: \(error)")
                }
            }
        }).resume()
    }
}
