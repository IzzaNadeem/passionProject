//
//  Image Helper.swift
//  passionProject
//
//  Created by C4Q on 5/20/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum AppError: Error {
    case badURL(url: String)
    case badImageURL(url: String)
    case badData
    case badResponseCode(code: Int)
    case cannotParseJSON(rawError: Error)
    case noInternet
    case other(rawError: Error)
}

class ImageHelper {
    private init() {}
    static let manager = ImageHelper()
    func loadImage(urlString: String, completionHandler: @escaping (Error?, UIImage?) -> Void) {
        if let image = ImageCaching.manager.retrieveImage(url: urlString) {
            completionHandler(nil, image)
            return
        }
        guard let url = URL(string: urlString) else {
            completionHandler(AppError.badURL(url: urlString), nil)
            return
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: { (data) in
            guard let image = UIImage(data: data) else {
                completionHandler(AppError.badData, nil)
                return
            }
            ImageCaching.manager.cacheImage(url: urlString, image: image)
            completionHandler(nil, image)
        }) { (error) in
            completionHandler(AppError.other(rawError: error), nil)
        }
    }
}

