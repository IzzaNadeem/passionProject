//
//  unsplashAPI.swift
//  passionProject
//
//  Created by C4Q on 5/20/18.
//  Copyright © 2018 C4Q. All rights reserved.
//https://api.unsplash.com/photos/random/?client_id=7a1d999e2d6d123734240262b691a70c99394e87882ec4982266d7dbd6635383

import Foundation
class ImageAPI {
    private init() {}
    static let manager = ImageAPI()
    func getImage(completionHandler: @escaping (Error?, URLS?) -> Void) {
        let urlString = "https://api.unsplash.com/photos/random?query=nature&client_id=7a1d999e2d6d123734240262b691a70c99394e87882ec4982266d7dbd6635383"
        guard let url = URL(string: urlString) else {
            completionHandler(AppError.badURL(url: urlString), nil)
            return
        }
        
        NetworkHelper.manager.performDataTask(with: url, completionHandler: { (data) in
            let json = JSONDecoder()
            let results = try? json.decode(firstWrapper.self, from: data)
            let imageResults = results?.urls
            completionHandler(nil, imageResults)
        }, errorHandler: { (error) in
            completionHandler(AppError.other(rawError: error), nil)
        })
    }
}
