//
//  NetworkSession.swift
//  passionProject
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

class NetworkSession {
    private init() {}
    static let shared = NetworkSession()
    let urlSession = URLSession(configuration: .default)
}

