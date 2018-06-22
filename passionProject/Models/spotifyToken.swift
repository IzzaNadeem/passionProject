//
//  SpotifyToken.swift
//  passionProject
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

//holds reference to the token we received after the second handshake in OAuth
//use to traverse the json content the second handshake gives us, to get the actual token
//use this to convert the data we get back from the second handshake into json
struct SpotifyToken: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String
    let scope: String
}
