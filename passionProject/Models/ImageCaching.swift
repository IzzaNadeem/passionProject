//
//  ImageCaching.swift
//  passionProject
//
//  Created by C4Q on 5/21/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ImageCaching {
    private init() {}
    static let manager = ImageCaching()
    var nscashe = NSCache<NSString,UIImage>()
    
    func cacheImage(url: String, image: UIImage) {
        nscashe.setObject(image, forKey: (url as NSString))
        
    }
    func retrieveImage(url: String) -> UIImage? {
        return nscashe.object(forKey: url as NSString)
    }
}
